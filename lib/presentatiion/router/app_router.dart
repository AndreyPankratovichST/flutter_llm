import 'package:flutter/widgets.dart';
import 'package:flutter_llm/presentatiion/pages/chat_page.dart';
import 'package:flutter_llm/presentatiion/pages/loading_page.dart';
import 'package:flutter_llm/presentatiion/router/app_routes.dart';

final class AppRouter {
  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.init: (_) => LoadingPage(),
      AppRoutes.chat: (_) => ChatPage(),
    };
  }
}
