import 'package:flutter_llm/core/app_logger.dart';
import 'package:flutter_llm/domain/core/result.dart';

final class Unit {
  const Unit._();
  static const instance = Unit._();
}

abstract class UseCase<T, P> {
  late final AppLogger _logger = AppLogger(runtimeType.toString());

  Future<Result<T>> call(P params) async {
    try {
      final data = await execute(params);
      return Success(data);
    } catch (e, s) {
      _logger.error('execute failed', e, s);
      return Failure(e.toString());
    }
  }

  Future<T> execute(P params);
}

abstract class UseCaseNoParams<T> {
  late final AppLogger _logger = AppLogger(runtimeType.toString());

  Future<Result<T>> call() async {
    try {
      final data = await execute();
      return Success(data);
    } catch (e, s) {
      _logger.error('execute failed', e, s);
      return Failure(e.toString());
    }
  }

  Future<T> execute();
}

abstract class StreamUseCase<T, P> {
  late final AppLogger _logger = AppLogger(runtimeType.toString());

  Stream<Result<T>> call(P params) async* {
    try {
      await for (final item in execute(params)) {
        yield Success(item);
      }
    } catch (e, s) {
      _logger.error('execute failed', e, s);
      yield Failure(e.toString());
    }
  }

  Stream<T> execute(P params);
}
