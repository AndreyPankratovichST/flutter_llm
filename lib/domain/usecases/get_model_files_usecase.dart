import 'package:flutter_llm/domain/core/usecase.dart';
import 'package:flutter_llm/domain/entities/model_file.dart';
import 'package:flutter_llm/domain/repositories/model_repository.dart';

class GetModelFilesUseCase extends UseCase<List<ModelFile>, String> {
  GetModelFilesUseCase({required ModelRepository repository})
    : _repository = repository;

  final ModelRepository _repository;

  @override
  Future<List<ModelFile>> execute(String modelId) {
    return _repository.getModelFiles(modelId);
  }
}
