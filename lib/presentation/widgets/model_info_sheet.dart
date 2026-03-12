import 'package:flutter/material.dart';
import 'package:flutter_llm/domain/entities/model_info.dart';
import 'package:flutter_llm/presentation/utils/app_dimens.dart';
import 'package:flutter_llm/presentation/utils/constants.dart';

final class ModelInfoSheet extends StatelessWidget {
  const ModelInfoSheet({required this.modelInfo, super.key});

  final ModelInfo modelInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: AppDimens.spacingXxl,
              height: AppDimens.spacingXs,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(
                  alpha: AppDimens.sheetHandleAlpha,
                ),
                borderRadius: const BorderRadius.all(AppDimens.radiusSm),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spacingLg),
          Text(
            Constants.modelInfo,
            style: textTheme.titleLarge,
          ),
          if (modelInfo.name.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spacingSm),
            Text(
              modelInfo.name,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppDimens.spacingLg),
          _InfoRow(
            label: Constants.architecture,
            value: modelInfo.architecture.isNotEmpty
                ? modelInfo.architecture
                : Constants.unknown,
          ),
          _InfoRow(
            label: Constants.contextSize,
            value: modelInfo.contextSize > 0
                ? '${modelInfo.contextSize}'
                : Constants.unknown,
          ),
          _InfoRow(
            label: Constants.backend,
            value: modelInfo.backendName,
          ),
          if (modelInfo.parameters.isNotEmpty)
            _InfoRow(
              label: Constants.parameters,
              value: modelInfo.parameters,
            ),
          if (modelInfo.quantization.isNotEmpty)
            _InfoRow(
              label: Constants.quantization,
              value: modelInfo.quantization,
            ),
          _InfoRow(
            label: Constants.visionSupport,
            value: modelInfo.supportsVision
                ? Constants.supported
                : Constants.notSupported,
          ),
          _InfoRow(
            label: Constants.audioSupport,
            value: modelInfo.supportsAudio
                ? Constants.supported
                : Constants.notSupported,
          ),
          const SizedBox(height: AppDimens.spacingLg),
        ],
      ),
    );
  }
}

final class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyMedium = theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingXs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
