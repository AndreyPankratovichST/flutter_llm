import 'package:flutter_llm/di/app_di.dart';
import 'package:flutter_llm/di/platform_services_stub.dart'
    if (dart.library.io) 'package:flutter_llm/di/platform_services_native.dart'
    if (dart.library.js_interop) 'package:flutter_llm/di/platform_services_web.dart';
import 'package:flutter_llm/data/repositories/model_repository_impl.dart';
import 'package:flutter_llm/data/services/download_metadata_service.dart';
import 'package:flutter_llm/data/services/huggingface_api_service.dart';
import 'package:flutter_llm/data/services/impl/huggingface_api_service_impl.dart';
import 'package:flutter_llm/data/services/llm_service.dart';
import 'package:flutter_llm/data/services/model_storage_service.dart';
import 'package:flutter_llm/domain/repositories/llm_repository.dart';
import 'package:flutter_llm/data/repositories/llm_repository_impl.dart';
import 'package:flutter_llm/domain/repositories/model_repository.dart';
import 'package:flutter_llm/domain/usecases/delete_model_usecase.dart';
import 'package:flutter_llm/domain/usecases/download_model_usecase.dart';
import 'package:flutter_llm/domain/usecases/get_local_models_usecase.dart';
import 'package:flutter_llm/domain/usecases/get_model_files_usecase.dart';
import 'package:flutter_llm/domain/usecases/get_model_info_usecase.dart';
import 'package:flutter_llm/domain/usecases/get_partial_file_size_usecase.dart';
import 'package:flutter_llm/domain/usecases/get_pending_downloads_usecase.dart';
import 'package:flutter_llm/domain/usecases/llm_dispose_usecase.dart';
import 'package:flutter_llm/domain/usecases/llm_init_usecase.dart';
import 'package:flutter_llm/domain/usecases/llm_send_message_usecase.dart';
import 'package:flutter_llm/domain/usecases/remove_download_metadata_usecase.dart';
import 'package:flutter_llm/domain/usecases/search_models_usecase.dart';
import 'package:flutter_llm/presentation/blocs/chat/chat_bloc.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_bloc.dart';
import 'package:flutter_llm/presentation/blocs/model_list/model_list_bloc.dart';
import 'package:flutter_llm/presentation/blocs/model_loader/model_loader_bloc.dart';
import 'package:flutter_llm/presentation/blocs/model_search/model_search_bloc.dart';

void configDi() {
  // Services — platform-specific implementations via conditional imports
  getIt.registerSingleton<HuggingFaceApiService>(HuggingFaceApiServiceImpl());
  getIt.registerSingleton<ModelStorageService>(createModelStorageService());
  getIt.registerSingleton<LLMService>(createLLMService());
  getIt.registerSingleton<DownloadMetadataService>(
    createDownloadMetadataService(),
  );

  // Repositories
  getIt.registerSingleton<ModelRepository>(
    ModelRepositoryImpl(
      apiService: getIt<HuggingFaceApiService>(),
      storageService: getIt<ModelStorageService>(),
      downloadMetadataService: getIt<DownloadMetadataService>(),
    ),
  );
  getIt.registerSingleton<LLMRepository>(
    LLMRepositoryImpl(service: getIt<LLMService>()),
  );

  // Use cases — LLM
  getIt.registerSingleton(LLMInitUseCase(repository: getIt<LLMRepository>()));
  getIt.registerSingleton(
    LLMDisposeUseCase(repository: getIt<LLMRepository>()),
  );
  getIt.registerSingleton(
    LLMSendMessageUseCase(repository: getIt<LLMRepository>()),
  );
  getIt.registerSingleton(
    GetModelInfoUseCase(repository: getIt<LLMRepository>()),
  );

  // Use cases — Model management
  getIt.registerSingleton(
    SearchModelsUseCase(repository: getIt<ModelRepository>()),
  );
  getIt.registerSingleton(
    GetModelFilesUseCase(repository: getIt<ModelRepository>()),
  );
  getIt.registerSingleton(
    DownloadModelUseCase(repository: getIt<ModelRepository>()),
  );
  getIt.registerSingleton(
    GetLocalModelsUseCase(repository: getIt<ModelRepository>()),
  );
  getIt.registerSingleton(
    DeleteModelUseCase(repository: getIt<ModelRepository>()),
  );
  getIt.registerSingleton(
    GetPendingDownloadsUseCase(repository: getIt<ModelRepository>()),
  );
  getIt.registerSingleton(
    GetPartialFileSizeUseCase(repository: getIt<ModelRepository>()),
  );
  getIt.registerSingleton(
    RemoveDownloadMetadataUseCase(repository: getIt<ModelRepository>()),
  );

  // BLoCs
  getIt.registerFactory(
    () => ModelLoaderBloc(
      initUseCase: getIt<LLMInitUseCase>(),
      disposeUseCase: getIt<LLMDisposeUseCase>(),
      getModelInfoUseCase: getIt<GetModelInfoUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => ChatBloc(
      sendMessageUseCase: getIt<LLMSendMessageUseCase>(),
      disposeUseCase: getIt<LLMDisposeUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => ModelListBloc(
      getLocalModelsUseCase: getIt<GetLocalModelsUseCase>(),
      deleteModelUseCase: getIt<DeleteModelUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => ModelSearchBloc(
      searchModelsUseCase: getIt<SearchModelsUseCase>(),
      getModelFilesUseCase: getIt<GetModelFilesUseCase>(),
    ),
  );

  // Singleton BLoC — lives for the entire app lifecycle
  getIt.registerSingleton(
    DownloadManagerBloc(
      downloadModelUseCase: getIt<DownloadModelUseCase>(),
      getPendingDownloadsUseCase: getIt<GetPendingDownloadsUseCase>(),
      getPartialFileSizeUseCase: getIt<GetPartialFileSizeUseCase>(),
      removeDownloadMetadataUseCase: getIt<RemoveDownloadMetadataUseCase>(),
    ),
  );
}
