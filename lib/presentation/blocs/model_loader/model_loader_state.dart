import 'package:flutter_llm/domain/entities/model_info.dart';

sealed class ModelLoaderState {}

final class ModelLoaderInitial extends ModelLoaderState {}

final class ModelLoading extends ModelLoaderState {}

final class ModelLoaded extends ModelLoaderState {
  ModelLoaded(this.modelInfo);

  final ModelInfo? modelInfo;
}

final class ModelLoadError extends ModelLoaderState {
  ModelLoadError(this.error);

  final String error;
}
