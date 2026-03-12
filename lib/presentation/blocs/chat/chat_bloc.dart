import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_llm/domain/core/result.dart';
import 'package:flutter_llm/domain/entities/message.dart';
import 'package:flutter_llm/domain/usecases/llm_dispose_usecase.dart';
import 'package:flutter_llm/domain/usecases/llm_send_message_usecase.dart';
import 'package:flutter_llm/presentation/blocs/chat/chat_event.dart';
import 'package:flutter_llm/presentation/blocs/chat/chat_state.dart';
import 'package:flutter_llm/presentation/utils/constants.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required LLMSendMessageUseCase sendMessageUseCase,
    required LLMDisposeUseCase disposeUseCase,
  }) : _sendMessageUseCase = sendMessageUseCase,
       _disposeUseCase = disposeUseCase,
       super(const ChatState()) {
    on<SendMessage>(_onSendMessage);
    on<DisposeModel>(_onDisposeModel);
  }

  final LLMSendMessageUseCase _sendMessageUseCase;
  final LLMDisposeUseCase _disposeUseCase;
  StreamSubscription<Result<String>>? _generationSubscription;

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isGenerating || event.text.trim().isEmpty) return;

    final userMessage = Message(text: event.text, isUser: true);
    final assistantMessage = Message(text: '', isUser: false);

    emit(
      state.copyWith(
        messages: [...state.messages, userMessage, assistantMessage],
        isGenerating: true,
      ),
    );

    final buffer = StringBuffer();
    final stream = _sendMessageUseCase(event.text);
    final completer = Completer<void>();

    _generationSubscription = stream.listen(
      (result) {
        switch (result) {
          case Success(:final data):
            buffer.write(data);
            final updated = List<Message>.of(state.messages);
            updated.last = assistantMessage.copyWith(text: buffer.toString());
            emit(state.copyWith(messages: updated));
          case Failure(:final error):
            final updated = List<Message>.of(state.messages);
            final errorText = buffer.isEmpty
                ? '${Constants.generationError}\n$error'
                : '$buffer\n\n${Constants.generationError}\n$error';
            updated.last = assistantMessage.copyWith(text: errorText);
            emit(state.copyWith(messages: updated));
        }
      },
      onDone: () {
        _generationSubscription = null;
        emit(state.copyWith(isGenerating: false));
        completer.complete();
      },
    );

    await completer.future;
  }

  Future<void> _onDisposeModel(
    DisposeModel event,
    Emitter<ChatState> emit,
  ) async {
    await _cancelGeneration();
    await _disposeUseCase();
  }

  Future<void> _cancelGeneration() async {
    await _generationSubscription?.cancel();
    _generationSubscription = null;
  }

  @override
  Future<void> close() async {
    await _cancelGeneration();
    return super.close();
  }
}
