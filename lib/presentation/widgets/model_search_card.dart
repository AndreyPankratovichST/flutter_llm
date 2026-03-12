import 'package:flutter/material.dart';
import 'package:flutter_llm/domain/entities/huggingface_model.dart';
import 'package:flutter_llm/presentation/utils/app_dimens.dart';
import 'package:flutter_llm/presentation/utils/constants.dart';

class ModelSearchCard extends StatelessWidget {
  const ModelSearchCard({
    required this.model,
    required this.isExpanded,
    required this.onTap,
    required this.expandedContent,
    super.key,
  });

  final HuggingFaceModel model;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget expandedContent;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingLg,
        vertical: AppDimens.spacingXs,
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              model.id,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${_formatNumber(model.downloads)} ${Constants.downloads}'
              ' · ♥ ${_formatNumber(model.likes)}'
              '${model.pipelineTag != null ? ' · ${model.pipelineTag}' : ''}',
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: onTap,
          ),
          if (isExpanded) expandedContent,
        ],
      ),
    );
  }

  static String _formatNumber(int n) {
    const thousand = 1000;
    const million = 1000000;
    if (n >= million) return '${(n / million).toStringAsFixed(1)}M';
    if (n >= thousand) return '${(n / thousand).toStringAsFixed(1)}K';
    return '$n';
  }
}
