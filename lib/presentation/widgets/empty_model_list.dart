import 'package:flutter/material.dart';
import 'package:flutter_llm/presentation/utils/app_dimens.dart';
import 'package:flutter_llm/presentation/utils/constants.dart';

class EmptyModelList extends StatelessWidget {
  const EmptyModelList({required this.onSearch, super.key});

  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spacingXxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.download_rounded,
              size: AppDimens.iconSizeLg,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: AppDimens.spacingLg),
            Text(
              Constants.noModelsTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimens.spacingSm),
            Text(
              Constants.noModelsSubtitle,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spacingXl),
            FilledButton.icon(
              onPressed: onSearch,
              icon: const Icon(Icons.search),
              label: const Text(Constants.searchModels),
            ),
          ],
        ),
      ),
    );
  }
}
