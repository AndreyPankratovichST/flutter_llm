import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_llm/domain/core/result.dart';
import 'package:flutter_llm/domain/usecases/get_model_files_usecase.dart';
import 'package:flutter_llm/domain/usecases/search_models_usecase.dart';
import 'package:flutter_llm/presentation/blocs/model_search/model_search_event.dart';
import 'package:flutter_llm/presentation/blocs/model_search/model_search_state.dart';

class ModelSearchBloc extends Bloc<ModelSearchEvent, ModelSearchState> {
  ModelSearchBloc({
    required SearchModelsUseCase searchModelsUseCase,
    required GetModelFilesUseCase getModelFilesUseCase,
  }) : _searchModelsUseCase = searchModelsUseCase,
       _getModelFilesUseCase = getModelFilesUseCase,
       super(const ModelSearchState()) {
    on<SearchModels>(_onSearch);
    on<ChangePipelineTag>(_onChangeTag);
    on<ToggleModelExpansion>(_onToggle);
  }

  final SearchModelsUseCase _searchModelsUseCase;
  final GetModelFilesUseCase _getModelFilesUseCase;

  String _lastQuery = '';

  Future<void> _onSearch(
    SearchModels event,
    Emitter<ModelSearchState> emit,
  ) async {
    _lastQuery = event.query;
    emit(
      state.copyWith(
        searching: true,
        error: () => null,
        expandedModelId: () => null,
        files: () => null,
      ),
    );

    final result = await _searchModelsUseCase((
      query: event.query,
      pipelineTag: state.selectedTag,
    ));
    switch (result) {
      case Success(:final data):
        emit(state.copyWith(searching: false, results: () => data));
      case Failure(:final error):
        emit(state.copyWith(searching: false, error: () => error));
    }
  }

  Future<void> _onChangeTag(
    ChangePipelineTag event,
    Emitter<ModelSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedTag: event.tag,
        results: () => null,
        expandedModelId: () => null,
        files: () => null,
      ),
    );
    if (_lastQuery.isNotEmpty) {
      add(SearchModels(_lastQuery));
    }
  }

  Future<void> _onToggle(
    ToggleModelExpansion event,
    Emitter<ModelSearchState> emit,
  ) async {
    if (state.expandedModelId == event.modelId) {
      emit(state.copyWith(expandedModelId: () => null, files: () => null));
      return;
    }

    emit(
      state.copyWith(
        expandedModelId: () => event.modelId,
        files: () => null,
        loadingFiles: true,
      ),
    );

    if (!state.selectedTag.isTextGeneration) {
      emit(state.copyWith(loadingFiles: false));
      return;
    }

    final result = await _getModelFilesUseCase(event.modelId);
    switch (result) {
      case Success(:final data):
        emit(state.copyWith(files: () => data, loadingFiles: false));
      case Failure(:final error):
        emit(state.copyWith(loadingFiles: false, error: () => error));
    }
  }
}
