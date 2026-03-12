import 'package:flutter_llm/domain/core/usecase.dart';
import 'package:flutter_llm/domain/entities/model_info.dart';
import 'package:flutter_llm/domain/repositories/llm_repository.dart';

class GetModelInfoUseCase extends UseCaseNoParams<ModelInfo> {
  GetModelInfoUseCase({required LLMRepository repository})
    : _repository = repository;

  final LLMRepository _repository;

  @override
  Future<ModelInfo> execute() {
    return _repository.getModelInfo();
  }
}
