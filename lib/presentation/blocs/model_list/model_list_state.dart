import 'package:flutter_llm/domain/entities/local_model.dart';

sealed class ModelListState {}

final class ModelListInitial extends ModelListState {}

final class ModelListLoading extends ModelListState {}

final class ModelListLoaded extends ModelListState {
  ModelListLoaded(this.models);

  final List<LocalModel> models;
}

final class ModelListError extends ModelListState {
  ModelListError(this.error);

  final String error;
}
