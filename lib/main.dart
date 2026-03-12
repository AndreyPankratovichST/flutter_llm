import 'package:flutter/material.dart';
import 'package:flutter_llm/di/app_di.dart';
import 'package:flutter_llm/di/app_di_config.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_bloc.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_event.dart';
import 'package:flutter_llm/presentation/pages/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configDi();

  getIt<DownloadManagerBloc>().add(ResumePendingDownloads());

  runApp(const App());
}
