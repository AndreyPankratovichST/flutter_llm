import 'package:flutter/material.dart';
import 'package:flutter_llm/di/app_di_config.dart';
import 'package:flutter_llm/presentatiion/pages/app.dart';

void main() async {
  await configDi();
  runApp(const App());
}
