import 'package:flutter_llm/domain/entities/message.dart';
import 'package:flutter_llm/domain/repositories/llm_repository.dart';

class LLMSendMessageUsecase {
  LLMSendMessageUsecase({required LLMRepository repository})
    : _repository = repository;

  final LLMRepository _repository;

  Future<void> execute(Message message) async {
    await _repository.sendMessage(message);
  }
}