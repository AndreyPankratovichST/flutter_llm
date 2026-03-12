import 'package:flutter_llm/domain/core/usecase.dart';
import 'package:flutter_llm/domain/repositories/model_repository.dart';

class DeleteModelUseCase extends UseCase<Unit, String> {
  DeleteModelUseCase({required ModelRepository repository})
    : _repository = repository;

  final ModelRepository _repository;

  @override
  Future<Unit> execute(String path) async {
    await _repository.deleteModel(path);
    return Unit.instance;
  }
}
