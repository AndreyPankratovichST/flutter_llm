import 'dart:async';

import 'package:flutter_llm/di/app_di.dart';
import 'package:flutter_llm/domain/repositories/llm_repository.dart';
import 'package:flutter_llm/data/repositories/llm_repository_impl.dart';
import 'package:flutter_llm/domain/usecases/llm_dispose_usecase.dart';
import 'package:flutter_llm/domain/usecases/llm_init_usecase.dart';
import 'package:flutter_llm/domain/usecases/llm_messages_usecase.dart';
import 'package:flutter_llm/domain/usecases/llm_send_message_usecase.dart';
import 'package:flutter_llm/presentatiion/controllers/llm_controller.dart';

FutureOr<void> configDi() {
  AppDi.init();

  AppDi.resolve<LLMRepository>(LLMRepositoryImpl());

  AppDi.resolve(LLMInitUsecase(repository: AppDi.get()));
  AppDi.resolve(LLMDisposeUsecase(repository: AppDi.get()));
  AppDi.resolve(LLMSendMessageUsecase(repository: AppDi.get()));
  AppDi.resolve(LLMMessagesUsecase(repository: AppDi.get()));

  AppDi.resolve(
    LLMController(
      llmInitUsecase: AppDi.get(),
      llmDisposeUsecase: AppDi.get(),
      llmSendMessageUsecase: AppDi.get(),
      llmMessagesUsecase: AppDi.get(),
    ),
  );
}
