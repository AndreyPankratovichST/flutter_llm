import 'package:flutter_llm/domain/core/usecase.dart';
import 'package:flutter_llm/domain/entities/huggingface_model.dart';
import 'package:flutter_llm/domain/entities/pipeline_tag.dart';
import 'package:flutter_llm/domain/repositories/model_repository.dart';

typedef SearchModelsParams = ({String query, PipelineTag? pipelineTag});

class SearchModelsUseCase
    extends UseCase<List<HuggingFaceModel>, SearchModelsParams> {
  SearchModelsUseCase({required ModelRepository repository})
    : _repository = repository;

  final ModelRepository _repository;

  @override
  Future<List<HuggingFaceModel>> execute(SearchModelsParams params) {
    return _repository.searchModels(
      params.query,
      pipelineTag: params.pipelineTag,
    );
  }
}
