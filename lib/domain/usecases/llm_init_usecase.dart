import 'package:flutter_llm/domain/core/usecase.dart';
import 'package:flutter_llm/domain/repositories/llm_repository.dart';

class LLMInitUseCase extends UseCase<Unit, String> {
  LLMInitUseCase({required LLMRepository repository})
    : _repository = repository;

  final LLMRepository _repository;

  @override
  Future<Unit> execute(String modelPath) async {
    await _repository.initModel(modelPath);
    return Unit.instance;
  }
}
