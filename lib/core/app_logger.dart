import 'dart:developer' as dev;

class AppLogger {
  const AppLogger(this._tag);

  static const _warningLevel = 900;
  static const _errorLevel = 1000;

  final String _tag;

  void info(String message) {
    dev.log(message, name: _tag);
  }

  void warning(String message) {
    dev.log(message, name: _tag, level: _warningLevel);
  }

  void error(String message, Object error, StackTrace stackTrace) {
    dev.log(
      message,
      name: _tag,
      error: error,
      stackTrace: stackTrace,
      level: _errorLevel,
    );
  }
}
