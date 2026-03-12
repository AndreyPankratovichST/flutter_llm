import 'package:flutter_llm/data/services/llm_service.dart';
import 'package:flutter_llm/domain/entities/model_info.dart';
import 'package:llamadart/llamadart.dart';

final class LLMServiceImpl implements LLMService {
  static const _modelNotLoaded =
      'Model is not loaded. Call loadModel() first.';

  LlamaEngine? _engine;
  ChatSession? _session;

  @override
  Future<void> loadModel(String modelPath) async {
    await disposeModel();

    final engine = LlamaEngine(LlamaBackend());
    try {
      await engine.loadModel(modelPath);
    } catch (_) {
      await engine.dispose();
      rethrow;
    }
    _engine = engine;
    _session = ChatSession(engine);
  }

  @override
  Future<ModelInfo> getModelInfo() async {
    final engine = _engine;
    if (engine == null) {
      throw StateError(_modelNotLoaded);
    }

    final metadata = await engine.getMetadata();
    final contextSize = await engine.getContextSize();
    final backendName = await engine.getBackendName();
    final vision = await engine.supportsVision;
    final audio = await engine.supportsAudio;

    return ModelInfo(
      name: metadata['general.name'] ?? metadata['general.basename'] ?? '',
      architecture: metadata['general.architecture'] ?? '',
      contextSize: contextSize,
      backendName: backendName,
      supportsVision: vision,
      supportsAudio: audio,
      parameters: metadata['general.parameter_count'] ?? '',
      quantization: metadata['general.file_type'] ?? '',
    );
  }

  @override
  Future<void> disposeModel() async {
    _session = null;
    await _engine?.dispose();
    _engine = null;
  }

  @override
  Stream<String> sendQuery(String query) async* {
    final session = _session;
    if (session == null) {
      throw StateError(_modelNotLoaded);
    }

    await for (final chunk in session.create([LlamaTextContent(query)])) {
      final choices = chunk.choices;
      if (choices.isEmpty) continue;
      final content = choices.first.delta.content;
      if (content != null) {
        yield content;
      }
    }
  }
}
