sealed class ModelListEvent {}

final class LoadLocalModels extends ModelListEvent {}

final class DeleteLocalModel extends ModelListEvent {
  DeleteLocalModel(this.path);

  final String path;
}
