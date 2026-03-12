import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_llm/domain/core/result.dart';
import 'package:flutter_llm/domain/usecases/delete_model_usecase.dart';
import 'package:flutter_llm/domain/usecases/get_local_models_usecase.dart';
import 'package:flutter_llm/presentation/blocs/model_list/model_list_event.dart';
import 'package:flutter_llm/presentation/blocs/model_list/model_list_state.dart';

class ModelListBloc extends Bloc<ModelListEvent, ModelListState> {
  ModelListBloc({
    required GetLocalModelsUseCase getLocalModelsUseCase,
    required DeleteModelUseCase deleteModelUseCase,
  }) : _getLocalModelsUseCase = getLocalModelsUseCase,
       _deleteModelUseCase = deleteModelUseCase,
       super(ModelListInitial()) {
    on<LoadLocalModels>(_onLoad);
    on<DeleteLocalModel>(_onDelete);
  }

  final GetLocalModelsUseCase _getLocalModelsUseCase;
  final DeleteModelUseCase _deleteModelUseCase;

  Future<void> _onLoad(
    LoadLocalModels event,
    Emitter<ModelListState> emit,
  ) async {
    emit(ModelListLoading());
    final result = await _getLocalModelsUseCase();
    switch (result) {
      case Success(:final data):
        emit(ModelListLoaded(data));
      case Failure(:final error):
        emit(ModelListError(error));
    }
  }

  Future<void> _onDelete(
    DeleteLocalModel event,
    Emitter<ModelListState> emit,
  ) async {
    final result = await _deleteModelUseCase(event.path);
    switch (result) {
      case Success():
        add(LoadLocalModels());
      case Failure(:final error):
        emit(ModelListError(error));
    }
  }
}
