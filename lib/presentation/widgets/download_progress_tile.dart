import 'package:flutter/material.dart';
import 'package:flutter_llm/domain/entities/download_task.dart';
import 'package:flutter_llm/presentation/utils/app_dimens.dart';
import 'package:flutter_llm/presentation/utils/constants.dart';

class DownloadProgressTile extends StatelessWidget {
  const DownloadProgressTile({
    required this.task,
    required this.onCancel,
    super.key,
  });

  final DownloadTask task;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent =
        (task.progress * AppDimens.percentMultiplier).toInt();

    return ListTile(
      leading: const Icon(Icons.downloading),
      title: Text(
        task.filename,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(value: task.progress),
          const SizedBox(height: AppDimens.spacingXs),
          Text(
            '$percent% — ${Constants.downloading}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onCancel,
      ),
    );
  }
}
