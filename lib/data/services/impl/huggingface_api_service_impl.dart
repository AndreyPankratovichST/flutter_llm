import 'dart:convert';

import 'package:flutter_llm/data/services/huggingface_api_service.dart';
import 'package:flutter_llm/domain/entities/huggingface_model.dart';
import 'package:flutter_llm/domain/entities/model_file.dart';
import 'package:flutter_llm/domain/entities/pipeline_tag.dart';
import 'package:http/http.dart' as http;

final class HuggingFaceApiServiceImpl implements HuggingFaceApiService {
  static const _baseUrl = 'https://huggingface.co';
  static const _apiUrl = '$_baseUrl/api/models';
  static const _searchLimit = 20;
  static const _httpOk = 200;

  @override
  Future<List<HuggingFaceModel>> searchModels(
    String query, {
    PipelineTag? pipelineTag,
  }) async {
    final isText =
        pipelineTag == null || pipelineTag == PipelineTag.textGeneration;

    final queryParams = <String, String>{
      'search': query,
      'sort': 'downloads',
      'direction': '-1',
      'limit': '$_searchLimit',
    };

    if (isText) {
      queryParams['filter'] = 'gguf';
    }

    if (pipelineTag != null) {
      queryParams['pipeline_tag'] = pipelineTag.apiValue;
    }

    final uri = Uri.parse(_apiUrl).replace(queryParameters: queryParams);

    final response = await http.get(uri);
    if (response.statusCode != _httpOk) {
      throw Exception('HuggingFace API error: ${response.statusCode}');
    }

    final List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
    return json
        .map((item) => _parseModel(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ModelFile>> getModelFiles(String modelId) async {
    final uri = Uri.parse('$_apiUrl/$modelId');
    final response = await http.get(uri);
    if (response.statusCode != _httpOk) {
      throw Exception('HuggingFace API error: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final siblings = json['siblings'] as List<dynamic>? ?? [];

    return siblings
        .map((s) => s as Map<String, dynamic>)
        .where((s) => (s['rfilename'] as String).endsWith('.gguf'))
        .map(
          (s) => ModelFile(
            filename: s['rfilename'] as String,
            sizeBytes: (s['size'] as num?)?.toInt() ??
                ((s['lfs'] as Map<String, dynamic>?)?['size'] as num?)
                    ?.toInt() ??
                0,
          ),
        )
        .toList();
  }

  @override
  String getDownloadUrl(String modelId, String filename) {
    return '$_baseUrl/$modelId/resolve/main/$filename';
  }

  HuggingFaceModel _parseModel(Map<String, dynamic> json) {
    final id = json['id'] as String;
    return HuggingFaceModel(
      id: id,
      author: id.split('/').first,
      downloads: (json['downloads'] as num?)?.toInt() ?? 0,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      pipelineTag: json['pipeline_tag'] as String?,
    );
  }
}
