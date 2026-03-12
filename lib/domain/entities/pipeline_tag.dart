enum PipelineTag {
  textGeneration('text-generation', 'Text Generation'),
  textToImage('text-to-image', 'Text to Image'),
  textToVideo('text-to-video', 'Text to Video'),
  textToAudio('text-to-audio', 'Text to Audio');

  const PipelineTag(this.apiValue, this.displayName);

  final String apiValue;
  final String displayName;

  bool get isTextGeneration => this == PipelineTag.textGeneration;
}
