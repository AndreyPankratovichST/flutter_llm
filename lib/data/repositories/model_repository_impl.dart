import 'package:flutter_llm/data/services/download_metadata_service.dart';
import 'package:flutter_llm/data/services/huggingface_api_service.dart';
import 'package:flutter_llm/data/services/model_storage_service.dart';
import 'package:flutter_llm/domain/entities/download_task.dart';
import 'package:flutter_llm/domain/entities/huggingface_model.dart';
import 'package:flutter_llm/domain/entities/local_model.dart';
import 'package:flutter_llm/domain/entities/model_file.dart';
import 'package:flutter_llm/domain/entities/pipeline_tag.dart';
import 'package:flutter_llm/domain/repositories/model_repository.dart';

final class ModelRepositoryImpl implements ModelRepository {
  ModelRepositoryImpl({
    required HuggingFaceApiService apiService,
    required ModelStorageService storageService,
    required DownloadMetadataService downloadMetadataService,
  })  : _apiService = apiService,
        _storageService = storageService,
        _downloadMetadataService = downloadMetadataService;

  final HuggingFaceApiService _apiService;
  final ModelStorageService _storageService;
  final DownloadMetadataService _downloadMetadataService;

  @override
  Future<List<HuggingFaceModel>> searchModels(
    String query, {
    PipelineTag? pipelineTag,
  }) =>
      _apiService.searchModels(query, pipelineTag: pipelineTag);

  @override
  Future<List<ModelFile>> getModelFiles(String modelId) =>
      _apiService.getModelFiles(modelId);

  @override
  Stream<double> downloadModel(
    String modelId,
    String filename, {
    int startByte = 0,
  }) async* {
    final url = _apiService.getDownloadUrl(modelId, filename);
    final targetPath = await _storageService.getDownloadPath(filename);
    yield* _storageService.downloadModel(
      url,
      targetPath,
      startByte: startByte,
    );
  }

  @override
  String getDownloadUrl(String modelId, String filename) =>
      _apiService.getDownloadUrl(modelId, filename);

  @override
  Future<String> getDownloadPath(String filename) =>
      _storageService.getDownloadPath(filename);

  @override
  Future<int> getPartialFileSize(String targetPath) =>
      _storageService.getPartialFileSize(targetPath);

  @override
  Future<List<DownloadTaskMetadata>> getPendingDownloads() =>
      _downloadMetadataService.getAll();

  @override
  Future<void> saveDownloadMetadata(DownloadTaskMetadata metadata) =>
      _downloadMetadataService.save(metadata);

  @override
  Future<void> removeDownloadMetadata(String filename) =>
      _downloadMetadataService.remove(filename);

  @override
  Future<List<LocalModel>> getLocalModels() =>
      _storageService.getLocalModels();

  @override
  Future<void> deleteModel(String path) => _storageService.deleteModel(path);
}
