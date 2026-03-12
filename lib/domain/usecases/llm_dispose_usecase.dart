import 'package:flutter_llm/domain/core/usecase.dart';
import 'package:flutter_llm/domain/repositories/llm_repository.dart';

class LLMDisposeUseCase extends UseCaseNoParams<Unit> {
  LLMDisposeUseCase({required LLMRepository repository})
    : _repository = repository;

  final LLMRepository _repository;

  @override
  Future<Unit> execute() async {
    await _repository.disposeModel();
    return Unit.instance;
  }
}
