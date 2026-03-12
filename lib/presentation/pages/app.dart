import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_llm/di/app_di.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_bloc.dart';
import 'package:flutter_llm/presentation/router/app_router.dart';
import 'package:flutter_llm/presentation/router/app_routes.dart';
import 'package:flutter_llm/presentation/utils/constants.dart';

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<DownloadManagerBloc>(),
      child: MaterialApp(
        title: Constants.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.models,
        routes: AppRouter.routes,
      ),
    );
  }
}
