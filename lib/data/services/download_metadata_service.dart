import 'package:flutter_llm/domain/entities/download_task.dart';

abstract class DownloadMetadataService {
  Future<List<DownloadTaskMetadata>> getAll();
  Future<void> save(DownloadTaskMetadata metadata);
  Future<void> remove(String filename);
}
