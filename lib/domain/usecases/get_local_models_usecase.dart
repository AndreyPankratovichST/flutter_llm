import 'package:flutter_llm/domain/core/usecase.dart';
import 'package:flutter_llm/domain/entities/local_model.dart';
import 'package:flutter_llm/domain/repositories/model_repository.dart';

class GetLocalModelsUseCase extends UseCaseNoParams<List<LocalModel>> {
  GetLocalModelsUseCase({required ModelRepository repository})
    : _repository = repository;

  final ModelRepository _repository;

  @override
  Future<List<LocalModel>> execute() {
    return _repository.getLocalModels();
  }
}
