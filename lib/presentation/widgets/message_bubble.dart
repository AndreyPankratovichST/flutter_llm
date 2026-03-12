import 'package:flutter/material.dart';
import 'package:flutter_llm/domain/entities/message.dart';
import 'package:flutter_llm/presentation/utils/app_dimens.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width *
              AppDimens.bubbleMaxWidthFraction,
        ),
        margin: const EdgeInsets.symmetric(vertical: AppDimens.spacingXs),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacingBase,
          vertical: AppDimens.spacingMd,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: AppDimens.radiusMd,
            topRight: AppDimens.radiusMd,
            bottomLeft: isUser ? AppDimens.radiusMd : AppDimens.radiusSm,
            bottomRight: isUser ? AppDimens.radiusSm : AppDimens.radiusMd,
          ),
        ),
        child: SelectableText(
          message.text.isEmpty ? '...' : message.text,
          style: TextStyle(
            color: isUser
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
