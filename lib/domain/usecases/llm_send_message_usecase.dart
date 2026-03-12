import 'package:flutter_llm/domain/core/usecase.dart';
import 'package:flutter_llm/domain/repositories/llm_repository.dart';

class LLMSendMessageUseCase extends StreamUseCase<String, String> {
  LLMSendMessageUseCase({required LLMRepository repository})
    : _repository = repository;

  final LLMRepository _repository;

  @override
  Stream<String> execute(String text) {
    return _repository.sendMessage(text);
  }
}
