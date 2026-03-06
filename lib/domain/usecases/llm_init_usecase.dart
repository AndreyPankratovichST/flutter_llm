import 'package:flutter_llm/domain/repositories/llm_repository.dart';

class LLMInitUsecase {
  LLMInitUsecase({required LLMRepository repository})
    : _repository = repository;

  final LLMRepository _repository;

  Future<void> execute() async {
    await _repository.initModel();
  }
}
