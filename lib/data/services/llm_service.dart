import 'package:flutter_llm/domain/entities/model_info.dart';

abstract class LLMService {
  Future<void> loadModel(String modelPath);

  Future<void> disposeModel();

  Stream<String> sendQuery(String query);

  Future<ModelInfo> getModelInfo();
}
