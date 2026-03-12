final class HuggingFaceModel {
  const HuggingFaceModel({
    required this.id,
    required this.author,
    required this.downloads,
    required this.likes,
    this.pipelineTag,
  });

  final String id;
  final String author;
  final int downloads;
  final int likes;
  final String? pipelineTag;
}
