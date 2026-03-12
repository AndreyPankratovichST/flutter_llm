import 'dart:io';

import 'package:flutter_llm/data/services/model_storage_service.dart';
import 'package:flutter_llm/domain/entities/local_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

final class ModelStorageServiceImpl implements ModelStorageService {
  static const _modelsDir = 'models';
  static const _partSuffix = '.part';
  static const _ggufExtension = '.gguf';

  Future<Directory> _getModelsDirectory() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/$_modelsDir');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  @override
  Future<List<LocalModel>> getLocalModels() async {
    final dir = await _getModelsDirectory();
    final files = dir
        .listSync()
        .whereType<File>()
        .where(
          (f) =>
              f.path.endsWith(_ggufExtension) &&
              !f.path.endsWith('$_ggufExtension$_partSuffix'),
        );

    return files
        .map(
          (f) => LocalModel(
            name: f.uri.pathSegments.last,
            path: f.path,
            sizeBytes: f.lengthSync(),
          ),
        )
        .toList();
  }

  @override
  Future<String> getDownloadPath(String filename) async {
    final dir = await _getModelsDirectory();
    final baseName = filename.split('/').last;
    return '${dir.path}/$baseName';
  }

  @override
  Stream<double> downloadModel(
    String url,
    String targetPath, {
    int startByte = 0,
  }) async* {
    final partPath = '$targetPath$_partSuffix';
    final client = http.Client();

    try {
      final request = http.Request('GET', Uri.parse(url));
      if (startByte > 0) {
        request.headers['Range'] = 'bytes=$startByte-';
      }

      final response = await client.send(request);

      final contentLength = response.contentLength;
      final totalBytes =
          contentLength != null ? startByte + contentLength : null;
      var receivedBytes = startByte;

      final file = File(partPath);
      final sink = file.openWrite(
        mode: startByte > 0 ? FileMode.append : FileMode.write,
      );

      try {
        await for (final chunk in response.stream) {
          sink.add(chunk);
          receivedBytes += chunk.length;
          if (totalBytes != null && totalBytes > 0) {
            yield (receivedBytes / totalBytes).clamp(0.0, 1.0);
          }
        }
      } finally {
        await sink.flush();
        await sink.close();
      }

      await File(partPath).rename(targetPath);
    } finally {
      client.close();
    }
  }

  @override
  Future<int> getPartialFileSize(String targetPath) async {
    final partFile = File('$targetPath$_partSuffix');
    if (partFile.existsSync()) {
      return partFile.lengthSync();
    }
    return 0;
  }

  @override
  Future<void> deleteModel(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
    final partFile = File('$path$_partSuffix');
    if (partFile.existsSync()) {
      await partFile.delete();
    }
  }
}
