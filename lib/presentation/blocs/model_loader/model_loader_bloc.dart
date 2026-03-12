import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_llm/domain/core/result.dart';
import 'package:flutter_llm/domain/usecases/get_model_info_usecase.dart';
import 'package:flutter_llm/domain/usecases/llm_dispose_usecase.dart';
import 'package:flutter_llm/domain/usecases/llm_init_usecase.dart';
import 'package:flutter_llm/presentation/blocs/model_loader/model_loader_event.dart';
import 'package:flutter_llm/presentation/blocs/model_loader/model_loader_state.dart';

class ModelLoaderBloc extends Bloc<ModelLoaderEvent, ModelLoaderState> {
  ModelLoaderBloc({
    required LLMInitUseCase initUseCase,
    required LLMDisposeUseCase disposeUseCase,
    required GetModelInfoUseCase getModelInfoUseCase,
  }) : _initUseCase = initUseCase,
       _disposeUseCase = disposeUseCase,
       _getModelInfoUseCase = getModelInfoUseCase,
       super(ModelLoaderInitial()) {
    on<LoadModel>(_onLoadModel);
    on<UnloadModel>(_onUnloadModel);
  }

  final LLMInitUseCase _initUseCase;
  final LLMDisposeUseCase _disposeUseCase;
  final GetModelInfoUseCase _getModelInfoUseCase;

  Future<void> _onLoadModel(
    LoadModel event,
    Emitter<ModelLoaderState> emit,
  ) async {
    emit(ModelLoading());
    final result = await _initUseCase(event.modelPath);
    switch (result) {
      case Success():
        final infoResult = await _getModelInfoUseCase();
        switch (infoResult) {
          case Success(:final data):
            emit(ModelLoaded(data));
          case Failure():
            emit(ModelLoaded(null));
        }
      case Failure(:final error):
        emit(ModelLoadError(error));
    }
  }

  Future<void> _onUnloadModel(
    UnloadModel event,
    Emitter<ModelLoaderState> emit,
  ) async {
    await _disposeUseCase();
    emit(ModelLoaderInitial());
  }
}
