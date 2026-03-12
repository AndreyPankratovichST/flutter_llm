import 'dart:convert';

import 'package:flutter_llm/data/services/download_metadata_service.dart';
import 'package:flutter_llm/domain/entities/download_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DownloadMetadataServiceWebImpl implements DownloadMetadataService {
  static const _key = 'web_download_metadata';

  Future<List<DownloadTaskMetadata>> _read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];

    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => DownloadTaskMetadata.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _write(List<DownloadTaskMetadata> items) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_key, json);
  }

  @override
  Future<List<DownloadTaskMetadata>> getAll() => _read();

  @override
  Future<void> save(DownloadTaskMetadata metadata) async {
    final items = await _read();
    items.removeWhere((e) => e.filename == metadata.filename);
    items.add(metadata);
    await _write(items);
  }

  @override
  Future<void> remove(String filename) async {
    final items = await _read();
    items.removeWhere((e) => e.filename == filename);
    await _write(items);
  }
}
