import 'package:flutter_llm/domain/core/usecase.dart';
import 'package:flutter_llm/domain/repositories/model_repository.dart';

class GetPartialFileSizeUseCase extends UseCase<int, String> {
  GetPartialFileSizeUseCase({required ModelRepository repository})
    : _repository = repository;

  final ModelRepository _repository;

  @override
  Future<int> execute(String targetPath) {
    return _repository.getPartialFileSize(targetPath);
  }
}
