import 'package:flutter/material.dart';
import 'package:flutter_llm/di/app_di.dart';
import 'package:flutter_llm/presentatiion/controllers/llm_controller.dart';
import 'package:flutter_llm/presentatiion/utils/constants.dart';
import 'package:flutter_llm/presentatiion/widgets/chat_body.dart';

final class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: AppDi.get<LLMController>().listenMessages(),
              builder: (context, snapshot) {
                return ChatBody(messages: snapshot.data ?? []);
              },
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: Constants.messageHint,
              prefix: IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
            ),
            onFieldSubmitted: (value) {},
          ),
        ],
      ),
    );
  }
}
