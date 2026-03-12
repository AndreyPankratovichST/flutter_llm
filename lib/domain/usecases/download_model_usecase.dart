import 'package:flutter_llm/domain/core/usecase.dart';
import 'package:flutter_llm/domain/entities/download_task.dart';
import 'package:flutter_llm/domain/repositories/model_repository.dart';

typedef DownloadModelParams = ({
  String modelId,
  String filename,
  int startByte,
});

class DownloadModelUseCase extends StreamUseCase<double, DownloadModelParams> {
  DownloadModelUseCase({required ModelRepository repository})
    : _repository = repository;

  final ModelRepository _repository;

  @override
  Stream<double> execute(DownloadModelParams params) async* {
    final modelId = params.modelId;
    final filename = params.filename;

    final url = _repository.getDownloadUrl(modelId, filename);
    final targetPath = await _repository.getDownloadPath(filename);

    await _repository.saveDownloadMetadata(
      DownloadTaskMetadata(
        modelId: modelId,
        filename: filename,
        url: url,
        targetPath: targetPath,
      ),
    );

    // Metadata is intentionally kept on error to support download resumption.
    yield* _repository.downloadModel(
      modelId,
      filename,
      startByte: params.startByte,
    );

    await _repository.removeDownloadMetadata(filename);
  }
}
