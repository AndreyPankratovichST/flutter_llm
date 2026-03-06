import 'package:flutter_llm/domain/entities/message.dart';
import 'package:flutter_llm/domain/repositories/llm_repository.dart';

class LLMMessagesUsecase {
  LLMMessagesUsecase({required LLMRepository repository})
    : _repository = repository;

  final LLMRepository _repository;

  Stream<Message> execute() {
    return _repository.listenMessages();
  }
}
