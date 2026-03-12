import 'package:flutter_llm/domain/entities/model_info.dart';

abstract class LLMRepository {
  Future<void> initModel(String modelPath);

  Future<void> disposeModel();

  Stream<String> sendMessage(String text);

  Future<ModelInfo> getModelInfo();
}
