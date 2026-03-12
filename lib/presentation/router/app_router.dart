import 'package:flutter/widgets.dart';
import 'package:flutter_llm/presentation/pages/chat_page.dart';
import 'package:flutter_llm/presentation/pages/loading_page.dart';
import 'package:flutter_llm/presentation/pages/model_list_page.dart';
import 'package:flutter_llm/presentation/pages/model_search_page.dart';
import 'package:flutter_llm/presentation/router/app_routes.dart';

final class AppRouter {
  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.models: (_) => const ModelListPage(),
      AppRoutes.search: (_) => const ModelSearchPage(),
      AppRoutes.loading: (_) => const LoadingPage(),
      AppRoutes.chat: (_) => const ChatPage(),
    };
  }
}
