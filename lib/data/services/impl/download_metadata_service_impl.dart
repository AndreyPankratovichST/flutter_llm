import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_llm/data/services/download_metadata_service.dart';
import 'package:flutter_llm/domain/entities/download_task.dart';
import 'package:path_provider/path_provider.dart';

final class DownloadMetadataServiceImpl implements DownloadMetadataService {
  static const _fileName = 'download_metadata.json';

  /// Serialises concurrent read-write access to the metadata file.
  final _lock = _AsyncLock();

  Future<File> _getFile() async {
    final docs = await getApplicationDocumentsDirectory();
    return File('${docs.path}/$_fileName');
  }

  Future<List<DownloadTaskMetadata>> _read() async {
    final file = await _getFile();
    if (!file.existsSync()) {
      return [];
    }
    final content = await file.readAsString();
    if (content.isEmpty) {
      return [];
    }
    final list = jsonDecode(content) as List<dynamic>;
    return list
        .map((e) => DownloadTaskMetadata.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _write(List<DownloadTaskMetadata> items) async {
    final file = await _getFile();
    final json = jsonEncode(items.map((e) => e.toJson()).toList());
    await file.writeAsString(json);
  }

  @override
  Future<List<DownloadTaskMetadata>> getAll() => _lock.run(_read);

  @override
  Future<void> save(DownloadTaskMetadata metadata) => _lock.run(() async {
    final items = await _read();
    items.removeWhere((e) => e.filename == metadata.filename);
    items.add(metadata);
    await _write(items);
  });

  @override
  Future<void> remove(String filename) => _lock.run(() async {
    final items = await _read();
    items.removeWhere((e) => e.filename == filename);
    await _write(items);
  });
}

class _AsyncLock {
  Future<void>? _last;

  Future<T> run<T>(Future<T> Function() action) async {
    final previous = _last;
    final completer = Completer<void>();
    _last = completer.future;

    if (previous != null) {
      await previous;
    }

    try {
      return await action();
    } finally {
      completer.complete();
    }
  }
}
