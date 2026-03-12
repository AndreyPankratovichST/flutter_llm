import 'dart:convert';

import 'package:flutter_llm/data/services/model_storage_service.dart';
import 'package:flutter_llm/domain/entities/local_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Web implementation that stores model metadata in SharedPreferences.
///
/// On web, actual file download is deferred to [LLMServiceWebImpl] which uses
/// `loadModelFromUrl` with browser Cache Storage. This service only tracks
/// which models the user has "downloaded" (i.e. added to their library).
final class ModelStorageServiceWebImpl implements ModelStorageService {
  static const _modelsKey = 'web_local_models';

  Future<List<_WebModelEntry>> _readEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_modelsKey);
    if (raw == null || raw.isEmpty) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => _WebModelEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _writeEntries(List<_WebModelEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_modelsKey, json);
  }

  @override
  Future<List<LocalModel>> getLocalModels() async {
    final entries = await _readEntries();
    return entries
        .map(
          (e) => LocalModel(
            name: e.filename,
            path: e.url,
            sizeBytes: e.sizeBytes,
          ),
        )
        .toList();
  }

  @override
  Future<String> getDownloadPath(String filename) async {
    final entries = await _readEntries();
    final existing = entries.where((e) => e.filename == filename).firstOrNull;
    return existing?.url ?? filename;
  }

  @override
  Stream<double> downloadModel(
    String url,
    String targetPath, {
    int startByte = 0,
  }) async* {
    final baseName = url.split('/').last;
    final entries = await _readEntries();
    entries.removeWhere((e) => e.filename == baseName);
    entries.add(_WebModelEntry(filename: baseName, url: url, sizeBytes: 0));
    await _writeEntries(entries);
    yield 1.0;
  }

  @override
  Future<int> getPartialFileSize(String targetPath) async => 0;

  @override
  Future<void> deleteModel(String path) async {
    final entries = await _readEntries();
    entries.removeWhere((e) => e.url == path || e.filename == path);
    await _writeEntries(entries);
  }
}

final class _WebModelEntry {
  const _WebModelEntry({
    required this.filename,
    required this.url,
    required this.sizeBytes,
  });

  factory _WebModelEntry.fromJson(Map<String, dynamic> json) {
    return _WebModelEntry(
      filename: json['filename'] as String,
      url: json['url'] as String,
      sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
    );
  }

  final String filename;
  final String url;
  final int sizeBytes;

  Map<String, dynamic> toJson() => {
    'filename': filename,
    'url': url,
    'sizeBytes': sizeBytes,
  };
}
