import 'package:flutter_llm/data/services/download_metadata_service.dart';
import 'package:flutter_llm/data/services/impl/download_metadata_service_impl.dart';
import 'package:flutter_llm/data/services/impl/llm_service_impl.dart';
import 'package:flutter_llm/data/services/impl/model_storage_service_impl.dart';
import 'package:flutter_llm/data/services/llm_service.dart';
import 'package:flutter_llm/data/services/model_storage_service.dart';

LLMService createLLMService() => LLMServiceImpl();

ModelStorageService createModelStorageService() => ModelStorageServiceImpl();

DownloadMetadataService createDownloadMetadataService() =>
    DownloadMetadataServiceImpl();
