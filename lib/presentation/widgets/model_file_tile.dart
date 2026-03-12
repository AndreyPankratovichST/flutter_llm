import 'package:flutter/material.dart';
import 'package:flutter_llm/domain/entities/download_task.dart';
import 'package:flutter_llm/domain/entities/model_file.dart';
import 'package:flutter_llm/presentation/extensions/file_size_extension.dart';
import 'package:flutter_llm/presentation/utils/app_dimens.dart';

class ModelFileTile extends StatelessWidget {
  const ModelFileTile({
    required this.file,
    required this.isDownloading,
    required this.downloadProgress,
    required this.isDownloadDisabled,
    required this.onDownload,
    this.downloadStatus,
    super.key,
  });

  final ModelFile file;
  final bool isDownloading;
  final double downloadProgress;
  final bool isDownloadDisabled;
  final VoidCallback onDownload;
  final DownloadStatus? downloadStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = downloadStatus == DownloadStatus.completed;
    final isFailed = downloadStatus == DownloadStatus.failed;

    return ListTile(
      dense: true,
      title: Text(
        file.filename,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall,
      ),
      subtitle: isDownloading
          ? LinearProgressIndicator(value: downloadProgress)
          : Text(file.sizeBytes.sizeFormatted),
      trailing: _buildTrailing(
        theme: theme,
        isCompleted: isCompleted,
        isFailed: isFailed,
      ),
    );
  }

  Widget _buildTrailing({
    required ThemeData theme,
    required bool isCompleted,
    required bool isFailed,
  }) {
    if (isDownloading) {
      return Text(
        '${(downloadProgress * AppDimens.percentMultiplier).toInt()}%',
      );
    }
    if (isCompleted) {
      return Icon(Icons.check_circle, color: theme.colorScheme.primary);
    }
    if (isFailed) {
      return IconButton(
        icon: Icon(Icons.refresh, color: theme.colorScheme.error),
        onPressed: onDownload,
      );
    }
    return IconButton(
      icon: const Icon(Icons.download),
      onPressed: isDownloadDisabled ? null : onDownload,
    );
  }
}
