import 'package:flutter_llm/domain/entities/download_task.dart';

final class DownloadManagerState {
  const DownloadManagerState({this.tasks = const {}});

  final Map<String, DownloadTask> tasks;

  bool isDownloading(String filename) {
    final task = tasks[filename];
    return task != null && task.status == DownloadStatus.downloading;
  }

  bool hasActiveDownloads() {
    return tasks.values.any((t) => t.status == DownloadStatus.downloading);
  }

  double progressFor(String filename) {
    return tasks[filename]?.progress ?? 0;
  }

  DownloadManagerState copyWith({Map<String, DownloadTask>? tasks}) {
    return DownloadManagerState(tasks: tasks ?? this.tasks);
  }

  DownloadManagerState _updateTask(String filename, DownloadTask task) {
    return copyWith(tasks: {...tasks, filename: task});
  }

  DownloadManagerState withTaskUpdated(String filename, DownloadTask task) {
    return _updateTask(filename, task);
  }

  DownloadManagerState withTaskRemoved(String filename) {
    final updated = Map<String, DownloadTask>.of(tasks)..remove(filename);
    return copyWith(tasks: updated);
  }
}
