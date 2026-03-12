import 'package:flutter/material.dart';
import 'package:flutter_llm/domain/entities/message.dart';
import 'package:flutter_llm/presentation/utils/app_dimens.dart';
import 'package:flutter_llm/presentation/utils/constants.dart';
import 'package:flutter_llm/presentation/widgets/message_bubble.dart';

final class ChatBody extends StatelessWidget {
  const ChatBody({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  final List<Message> messages;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(
        child: Text(Constants.emptyChatPlaceholder),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingLg,
        vertical: AppDimens.spacingSm,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return MessageBubble(message: messages[index]);
      },
    );
  }
}
