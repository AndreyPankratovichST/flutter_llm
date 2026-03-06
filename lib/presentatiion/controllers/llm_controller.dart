import 'dart:async';

import 'package:flutter_llm/domain/entities/message.dart';
import 'package:flutter_llm/domain/usecases/llm_dispose_usecase.dart';
import 'package:flutter_llm/domain/usecases/llm_init_usecase.dart';
import 'package:flutter_llm/domain/usecases/llm_messages_usecase.dart';
import 'package:flutter_llm/domain/usecases/llm_send_message_usecase.dart';

class LLMController {
  LLMController({
    required LLMInitUsecase llmInitUsecase,
    required LLMDisposeUsecase llmDisposeUsecase,
    required LLMSendMessageUsecase llmSendMessageUsecase,
    required LLMMessagesUsecase llmMessagesUsecase,
  }) : _llmMessagesUsecase = llmMessagesUsecase,
       _llmInitUsecase = llmInitUsecase,
       _llmDisposeUsecase = llmDisposeUsecase,
       _llmSendMessageUsecase = llmSendMessageUsecase;

  final LLMInitUsecase _llmInitUsecase;
  final LLMDisposeUsecase _llmDisposeUsecase;
  final LLMSendMessageUsecase _llmSendMessageUsecase;
  final LLMMessagesUsecase _llmMessagesUsecase;

  StreamController<List<Message>>? _controller;
  StreamSubscription<Message>? _streamSubscription;

  Future<void> init() async {
    await _llmInitUsecase.execute();

    _controller = StreamController();
    _streamSubscription = _llmMessagesUsecase.execute().listen((message) async {
      await _addMessage(message);
    });
  }

  void dispose() {
    _llmDisposeUsecase.execute();
    _streamSubscription?.cancel();
    _controller?.close();
    _streamSubscription = null;
    _controller = null;
  }

  Future<void> sendMessage(String text, [Object? attachment]) async {
    final message = Message(text: text, attachment: attachment ?? {});
    await _addMessage(message);
    await _llmSendMessageUsecase.execute(message);
  }

  Stream<List<Message>> listenMessages() {
    if (_controller == null) {
      throw Exception('LLMController is not init');
    }
    return _controller!.stream;
  }

  Future<void> _addMessage(Message message) async {
    final values = await _controller?.stream.last ?? [];
    values.add(message);
    _controller?.add(values);
  }
}
