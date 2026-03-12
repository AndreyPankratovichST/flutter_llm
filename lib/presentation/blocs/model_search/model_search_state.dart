import 'package:flutter_llm/domain/entities/huggingface_model.dart';
import 'package:flutter_llm/domain/entities/model_file.dart';
import 'package:flutter_llm/domain/entities/pipeline_tag.dart';

final class ModelSearchState {
  const ModelSearchState({
    this.selectedTag = PipelineTag.textGeneration,
    this.results,
    this.searching = false,
    this.error,
    this.expandedModelId,
    this.files,
    this.loadingFiles = false,
  });

  final PipelineTag selectedTag;
  final List<HuggingFaceModel>? results;
  final bool searching;
  final String? error;
  final String? expandedModelId;
  final List<ModelFile>? files;
  final bool loadingFiles;

  ModelSearchState copyWith({
    PipelineTag? selectedTag,
    List<HuggingFaceModel>? Function()? results,
    bool? searching,
    String? Function()? error,
    String? Function()? expandedModelId,
    List<ModelFile>? Function()? files,
    bool? loadingFiles,
  }) {
    return ModelSearchState(
      selectedTag: selectedTag ?? this.selectedTag,
      results: results != null ? results() : this.results,
      searching: searching ?? this.searching,
      error: error != null ? error() : this.error,
      expandedModelId:
          expandedModelId != null ? expandedModelId() : this.expandedModelId,
      files: files != null ? files() : this.files,
      loadingFiles: loadingFiles ?? this.loadingFiles,
    );
  }
}
