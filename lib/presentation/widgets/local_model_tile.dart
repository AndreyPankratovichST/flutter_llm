import 'package:flutter/material.dart';
import 'package:flutter_llm/domain/entities/local_model.dart';
import 'package:flutter_llm/presentation/extensions/file_size_extension.dart';
import 'package:flutter_llm/presentation/utils/constants.dart';

class LocalModelTile extends StatelessWidget {
  const LocalModelTile({
    required this.model,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final LocalModel model;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(Constants.deleteModel),
        content: const Text(Constants.deleteModelConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(Constants.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(Constants.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.smart_toy_outlined),
      title: Text(model.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(model.sizeBytes.sizeFormatted),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () => _confirmDelete(context),
      ),
      onTap: onTap,
    );
  }
}
