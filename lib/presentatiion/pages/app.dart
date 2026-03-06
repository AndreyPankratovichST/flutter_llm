import 'package:flutter/material.dart';
import 'package:flutter_llm/di/app_di.dart';
import 'package:flutter_llm/presentatiion/controllers/llm_controller.dart';
import 'package:flutter_llm/presentatiion/router/app_router.dart';
import 'package:flutter_llm/presentatiion/router/app_routes.dart';
import 'package:flutter_llm/presentatiion/utils/constants.dart';

final class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final LLMController _llmController;

  @override
  void initState() {
    _llmController = AppDi.get()..init();
    super.initState();
  }

  @override
  void dispose() {
    _llmController.dispose();
    AppDi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      initialRoute: AppRoutes.init,
      routes: AppRouter.routes,
    );
  }
}
