import 'package:flutter_llm/domain/entities/pipeline_tag.dart';

sealed class ModelSearchEvent {}

final class SearchModels extends ModelSearchEvent {
  SearchModels(this.query);

  final String query;
}

final class ChangePipelineTag extends ModelSearchEvent {
  ChangePipelineTag(this.tag);

  final PipelineTag tag;
}

final class ToggleModelExpansion extends ModelSearchEvent {
  ToggleModelExpansion(this.modelId);

  final String modelId;
}
