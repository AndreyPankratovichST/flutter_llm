import 'package:flutter_llm/domain/entities/download_task.dart';
import 'package:flutter_llm/domain/entities/huggingface_model.dart';
import 'package:flutter_llm/domain/entities/local_model.dart';
import 'package:flutter_llm/domain/entities/model_file.dart';
import 'package:flutter_llm/domain/entities/pipeline_tag.dart';

abstract class ModelRepository {
  Future<List<HuggingFaceModel>> searchModels(
    String query, {
    PipelineTag? pipelineTag,
  });
  Future<List<ModelFile>> getModelFiles(String modelId);

  Stream<double> downloadModel(
    String modelId,
    String filename, {
    int startByte,
  });
  String getDownloadUrl(String modelId, String filename);
  Future<String> getDownloadPath(String filename);
  Future<int> getPartialFileSize(String targetPath);

  Future<List<DownloadTaskMetadata>> getPendingDownloads();
  Future<void> saveDownloadMetadata(DownloadTaskMetadata metadata);
  Future<void> removeDownloadMetadata(String filename);

  Future<List<LocalModel>> getLocalModels();
  Future<void> deleteModel(String path);
}
