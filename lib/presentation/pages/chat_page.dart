import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_llm/di/app_di.dart';
import 'package:flutter_llm/domain/entities/model_info.dart';
import 'package:flutter_llm/presentation/blocs/chat/chat_bloc.dart';
import 'package:flutter_llm/presentation/blocs/chat/chat_event.dart';
import 'package:flutter_llm/presentation/blocs/chat/chat_state.dart';
import 'package:flutter_llm/presentation/router/app_routes.dart';
import 'package:flutter_llm/presentation/utils/app_dimens.dart';
import 'package:flutter_llm/presentation/utils/constants.dart';
import 'package:flutter_llm/presentation/widgets/chat_body.dart';
import 'package:flutter_llm/presentation/widgets/model_info_sheet.dart';

final class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChatBloc>(),
      child: const _ChatView(),
    );
  }
}

final class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  ModelInfo? get _modelInfo =>
      ModalRoute.of(context)?.settings.arguments as ModelInfo?;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    context.read<ChatBloc>().add(SendMessage(text));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showModelInfo() {
    final info = _modelInfo;
    if (info == null) return;

    showModalBottomSheet<void>(
      context: context,
      builder: (_) => ModelInfoSheet(modelInfo: info),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<ChatBloc>().add(DisposeModel());
            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.models, (_) => false);
          },
        ),
        actions: [
          if (_modelInfo != null)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: _showModelInfo,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                _scrollToBottom();
                return ChatBody(
                  messages: state.messages,
                  scrollController: _scrollController,
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spacingLg,
        AppDimens.spacingSm,
        AppDimens.spacingSm,
        AppDimens.spacingLg,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppDimens.shadowAlpha),
            blurRadius: AppDimens.shadowBlur,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: Constants.messageHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(AppDimens.radiusLg),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimens.spacingLg,
                    vertical: AppDimens.spacingMd,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _onSend(),
              ),
            ),
            const SizedBox(width: AppDimens.spacingSm),
            BlocSelector<ChatBloc, ChatState, bool>(
              selector: (state) => state.isGenerating,
              builder: (context, isGenerating) {
                return IconButton.filled(
                  onPressed: isGenerating ? null : _onSend,
                  icon: isGenerating
                      ? const SizedBox(
                          width: AppDimens.indicatorSize,
                          height: AppDimens.indicatorSize,
                          child: CircularProgressIndicator(
                            strokeWidth: AppDimens.indicatorStroke,
                          ),
                        )
                      : const Icon(Icons.send),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
