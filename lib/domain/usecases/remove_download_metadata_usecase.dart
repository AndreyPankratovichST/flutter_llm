import 'package:flutter_llm/domain/core/usecase.dart';
import 'package:flutter_llm/domain/repositories/model_repository.dart';

class RemoveDownloadMetadataUseCase extends UseCase<Unit, String> {
  RemoveDownloadMetadataUseCase({required ModelRepository repository})
    : _repository = repository;

  final ModelRepository _repository;

  @override
  Future<Unit> execute(String filename) async {
    await _repository.removeDownloadMetadata(filename);
    return Unit.instance;
  }
}
