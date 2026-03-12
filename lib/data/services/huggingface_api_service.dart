import 'package:flutter_llm/domain/entities/huggingface_model.dart';
import 'package:flutter_llm/domain/entities/model_file.dart';
import 'package:flutter_llm/domain/entities/pipeline_tag.dart';

abstract class HuggingFaceApiService {
  Future<List<HuggingFaceModel>> searchModels(
    String query, {
    PipelineTag? pipelineTag,
  });
  Future<List<ModelFile>> getModelFiles(String modelId);
  String getDownloadUrl(String modelId, String filename);
}
