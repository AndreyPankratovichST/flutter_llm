import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_llm/domain/core/result.dart';
import 'package:flutter_llm/domain/entities/download_task.dart';
import 'package:flutter_llm/domain/usecases/download_model_usecase.dart';
import 'package:flutter_llm/domain/usecases/get_partial_file_size_usecase.dart';
import 'package:flutter_llm/domain/usecases/get_pending_downloads_usecase.dart';
import 'package:flutter_llm/domain/usecases/remove_download_metadata_usecase.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_event.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_state.dart';

class DownloadManagerBloc
    extends Bloc<DownloadManagerEvent, DownloadManagerState> {
  DownloadManagerBloc({
    required DownloadModelUseCase downloadModelUseCase,
    required GetPendingDownloadsUseCase getPendingDownloadsUseCase,
    required GetPartialFileSizeUseCase getPartialFileSizeUseCase,
    required RemoveDownloadMetadataUseCase removeDownloadMetadataUseCase,
  })  : _downloadModelUseCase = downloadModelUseCase,
        _getPendingDownloadsUseCase = getPendingDownloadsUseCase,
        _getPartialFileSizeUseCase = getPartialFileSizeUseCase,
        _removeDownloadMetadataUseCase = removeDownloadMetadataUseCase,
        super(const DownloadManagerState()) {
    on<StartDownload>(_onStart);
    on<CancelDownload>(_onCancel);
    on<ResumePendingDownloads>(_onResumePending);
    on<DownloadProgressUpdated>(_onProgress);
    on<DownloadCompleted>(_onCompleted);
    on<DownloadFailed>(_onFailed);
  }

  final DownloadModelUseCase _downloadModelUseCase;
  final GetPendingDownloadsUseCase _getPendingDownloadsUseCase;
  final GetPartialFileSizeUseCase _getPartialFileSizeUseCase;
  final RemoveDownloadMetadataUseCase _removeDownloadMetadataUseCase;

  final Map<String, StreamSubscription<Result<double>>> _subscriptions = {};
  final Set<String> _failedDownloads = {};

  Future<void> _onStart(
    StartDownload event,
    Emitter<DownloadManagerState> emit,
  ) async {
    if (state.isDownloading(event.filename)) return;

    final task = DownloadTask(
      modelId: event.modelId,
      filename: event.filename,
      status: DownloadStatus.downloading,
    );
    emit(state.withTaskUpdated(event.filename, task));

    _listen(
      modelId: event.modelId,
      filename: event.filename,
      startByte: 0,
    );
  }

  Future<void> _onCancel(
    CancelDownload event,
    Emitter<DownloadManagerState> emit,
  ) async {
    await _subscriptions[event.filename]?.cancel();
    _subscriptions.remove(event.filename);
    await _removeDownloadMetadataUseCase(event.filename);
    emit(state.withTaskRemoved(event.filename));
  }

  Future<void> _onResumePending(
    ResumePendingDownloads event,
    Emitter<DownloadManagerState> emit,
  ) async {
    final result = await _getPendingDownloadsUseCase();
    if (result case Success(:final data)) {
      for (final meta in data) {
        if (state.isDownloading(meta.filename)) continue;

        var startByte = 0;
        final sizeResult =
            await _getPartialFileSizeUseCase(meta.targetPath);
        if (sizeResult case Success(:final data)) {
          startByte = data;
        }

        final task = DownloadTask(
          modelId: meta.modelId,
          filename: meta.filename,
          status: DownloadStatus.downloading,
        );
        emit(state.withTaskUpdated(meta.filename, task));

        _listen(
          modelId: meta.modelId,
          filename: meta.filename,
          startByte: startByte,
        );
      }
    }
  }

  void _onProgress(
    DownloadProgressUpdated event,
    Emitter<DownloadManagerState> emit,
  ) {
    final current = state.tasks[event.filename];
    if (current == null) return;
    emit(state.withTaskUpdated(
      event.filename,
      current.copyWith(progress: event.progress),
    ));
  }

  void _onCompleted(
    DownloadCompleted event,
    Emitter<DownloadManagerState> emit,
  ) {
    _subscriptions.remove(event.filename);
    final current = state.tasks[event.filename];
    if (current == null) return;
    emit(state.withTaskUpdated(
      event.filename,
      current.copyWith(status: DownloadStatus.completed, progress: 1),
    ));
  }

  void _onFailed(
    DownloadFailed event,
    Emitter<DownloadManagerState> emit,
  ) {
    _subscriptions.remove(event.filename);
    final current = state.tasks[event.filename];
    if (current == null) return;
    emit(state.withTaskUpdated(
      event.filename,
      current.copyWith(status: DownloadStatus.failed),
    ));
  }

  void _listen({
    required String modelId,
    required String filename,
    required int startByte,
  }) {
    final stream = _downloadModelUseCase(
      (modelId: modelId, filename: filename, startByte: startByte),
    );

    _subscriptions[filename] = stream.listen(
      (result) {
        switch (result) {
          case Success(:final data):
            add(DownloadProgressUpdated(filename, data));
          case Failure(:final error):
            _failedDownloads.add(filename);
            add(DownloadFailed(filename, error));
        }
      },
      onDone: () {
        if (!_failedDownloads.remove(filename)) {
          add(DownloadCompleted(filename));
        }
      },
    );
  }

  @override
  Future<void> close() async {
    for (final sub in _subscriptions.values) {
      await sub.cancel();
    }
    _subscriptions.clear();
    return super.close();
  }
}
