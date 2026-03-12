sealed class DownloadManagerEvent {}

final class StartDownload extends DownloadManagerEvent {
  StartDownload({required this.modelId, required this.filename});

  final String modelId;
  final String filename;
}

final class CancelDownload extends DownloadManagerEvent {
  CancelDownload(this.filename);

  final String filename;
}

final class ResumePendingDownloads extends DownloadManagerEvent {}

final class DownloadProgressUpdated extends DownloadManagerEvent {
  DownloadProgressUpdated(this.filename, this.progress);

  final String filename;
  final double progress;
}

final class DownloadCompleted extends DownloadManagerEvent {
  DownloadCompleted(this.filename);

  final String filename;
}

final class DownloadFailed extends DownloadManagerEvent {
  DownloadFailed(this.filename, this.error);

  final String filename;
  final String error;
}
