import 'dart:async';

final class AppDi {
  AppDi._();

  final Map<Type, Object> _map = {};

  static AppDi? _instance;

  static FutureOr<void> init() async {
    if (_instance != null) {
      await dispose();
    }
    _instance = AppDi._();
  }

  static FutureOr<void> dispose() async {
    if (_instance != null) {
      _instance!._map.clear();
      _instance = null;
    }
  }

  static void resolve<T>(Object value) {
    if (_instance != null) {
      _instance!._map[T.runtimeType] = value;
    }
  }

  static T get<T>() {
    final value = _instance?._map[T.runtimeType];
    if (value == null) {
      throw Exception('${T.runtimeType} is not resolve in DI');
    }
    return value as T;
  }
}
