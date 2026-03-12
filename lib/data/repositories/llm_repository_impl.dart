import 'package:flutter_llm/data/services/llm_service.dart';
import 'package:flutter_llm/domain/entities/model_info.dart';
import 'package:flutter_llm/domain/repositories/llm_repository.dart';

class LLMRepositoryImpl extends LLMRepository {
  LLMRepositoryImpl({required LLMService service}) : _service = service;

  final LLMService _service;

  @override
  Future<void> initModel(String modelPath) async {
    await _service.loadModel(modelPath);
  }

  @override
  Future<void> disposeModel() async {
    await _service.disposeModel();
  }

  @override
  Stream<String> sendMessage(String text) {
    return _service.sendQuery(text);
  }

  @override
  Future<ModelInfo> getModelInfo() {
    return _service.getModelInfo();
  }
}
