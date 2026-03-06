import 'package:flutter_llm/domain/entities/message.dart';
import 'package:flutter_llm/domain/repositories/llm_repository.dart';

class LLMRepositoryImpl extends LLMRepository {
  @override
  Future<void> initModel() {
    // TODO: implement loadModel
    throw UnimplementedError();
  }

  @override
  Future<void> disposeModel() {
    // TODO: implement disposeModel
    throw UnimplementedError();
  }

  @override
  Stream<Message> listenMessages() {
    // TODO: implement listenMessages
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(Message message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
