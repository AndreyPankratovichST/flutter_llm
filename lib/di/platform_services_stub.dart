import 'package:flutter_llm/data/services/download_metadata_service.dart';
import 'package:flutter_llm/data/services/llm_service.dart';
import 'package:flutter_llm/data/services/model_storage_service.dart';

LLMService createLLMService() =>
    throw UnsupportedError('No platform implementation');

ModelStorageService createModelStorageService() =>
    throw UnsupportedError('No platform implementation');

DownloadMetadataService createDownloadMetadataService() =>
    throw UnsupportedError('No platform implementation');
