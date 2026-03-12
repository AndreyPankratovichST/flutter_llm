import 'package:flutter_llm/domain/core/usecase.dart';
import 'package:flutter_llm/domain/entities/download_task.dart';
import 'package:flutter_llm/domain/repositories/model_repository.dart';

class GetPendingDownloadsUseCase
    extends UseCaseNoParams<List<DownloadTaskMetadata>> {
  GetPendingDownloadsUseCase({required ModelRepository repository})
    : _repository = repository;

  final ModelRepository _repository;

  @override
  Future<List<DownloadTaskMetadata>> execute() {
    return _repository.getPendingDownloads();
  }
}
