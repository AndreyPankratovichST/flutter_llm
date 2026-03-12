sealed class ModelLoaderEvent {}

final class LoadModel extends ModelLoaderEvent {
  LoadModel(this.modelPath);

  final String modelPath;
}

final class UnloadModel extends ModelLoaderEvent {}
