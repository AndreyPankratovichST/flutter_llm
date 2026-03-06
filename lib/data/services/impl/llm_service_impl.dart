import 'package:flutter_llm/data/services/llm_service.dart';
import 'package:llamadart/llamadart.dart';

final class LLMServiceImpl implements LLMService {
  final engine = LlamaEngine(LlamaBackend());
  
  @override
  Future<void> loadModel() async {
    await engine.loadModel('path', modelParams: ModelParams());
  }
  
  @override
  Future<void> disposeModel() async {
    await engine.dispose();
  }
  
  @override
  Future<void> sendQuery(String query) {
    engine.generate(query);
  }
}
