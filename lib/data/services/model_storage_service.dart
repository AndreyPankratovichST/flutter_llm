import 'package:flutter_llm/domain/entities/local_model.dart';

abstract class ModelStorageService {
  Future<List<LocalModel>> getLocalModels();
  Future<String> getDownloadPath(String filename);
  Stream<double> downloadModel(String url, String targetPath, {int startByte});
  Future<int> getPartialFileSize(String targetPath);
  Future<void> deleteModel(String path);
}
