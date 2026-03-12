enum DownloadStatus { pending, downloading, completed, failed }

final class DownloadTask {
  const DownloadTask({
    required this.modelId,
    required this.filename,
    required this.status,
    this.progress = 0,
  });

  final String modelId;
  final String filename;
  final DownloadStatus status;
  final double progress;

  DownloadTask copyWith({
    DownloadStatus? status,
    double? progress,
  }) {
    return DownloadTask(
      modelId: modelId,
      filename: filename,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }
}

final class DownloadTaskMetadata {
  const DownloadTaskMetadata({
    required this.modelId,
    required this.filename,
    required this.url,
    required this.targetPath,
  });

  factory DownloadTaskMetadata.fromJson(Map<String, dynamic> json) {
    return DownloadTaskMetadata(
      modelId: json['modelId'] as String,
      filename: json['filename'] as String,
      url: json['url'] as String,
      targetPath: json['targetPath'] as String,
    );
  }

  final String modelId;
  final String filename;
  final String url;
  final String targetPath;

  Map<String, dynamic> toJson() => {
    'modelId': modelId,
    'filename': filename,
    'url': url,
    'targetPath': targetPath,
  };
}
