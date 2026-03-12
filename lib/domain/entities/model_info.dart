final class ModelInfo {
  const ModelInfo({
    required this.name,
    required this.architecture,
    required this.contextSize,
    required this.backendName,
    required this.supportsVision,
    required this.supportsAudio,
    required this.parameters,
    required this.quantization,
  });

  final String name;
  final String architecture;
  final int contextSize;
  final String backendName;
  final bool supportsVision;
  final bool supportsAudio;
  final String parameters;
  final String quantization;
}
