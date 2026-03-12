import 'package:flutter_llm/data/services/download_metadata_service.dart';
import 'package:flutter_llm/data/services/impl/download_metadata_service_web_impl.dart';
import 'package:flutter_llm/data/services/impl/llm_service_web_impl.dart';
import 'package:flutter_llm/data/services/impl/model_storage_service_web_impl.dart';
import 'package:flutter_llm/data/services/llm_service.dart';
import 'package:flutter_llm/data/services/model_storage_service.dart';

LLMService createLLMService() => LLMServiceWebImpl();

ModelStorageService createModelStorageService() =>
    ModelStorageServiceWebImpl();

DownloadMetadataService createDownloadMetadataService() =>
    DownloadMetadataServiceWebImpl();
