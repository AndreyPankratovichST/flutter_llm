abstract class LLMService {
  Future<void> loadModel();

  Future<void> disposeModel();

  Future<void> sendQuery(String query);
}