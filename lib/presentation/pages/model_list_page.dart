import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_llm/di/app_di.dart';
import 'package:flutter_llm/domain/entities/download_task.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_bloc.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_event.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_state.dart';
import 'package:flutter_llm/presentation/blocs/model_list/model_list_bloc.dart';
import 'package:flutter_llm/presentation/blocs/model_list/model_list_event.dart';
import 'package:flutter_llm/presentation/blocs/model_list/model_list_state.dart';
import 'package:flutter_llm/presentation/router/app_routes.dart';
import 'package:flutter_llm/presentation/utils/constants.dart';
import 'package:flutter_llm/presentation/widgets/download_progress_tile.dart';
import 'package:flutter_llm/presentation/widgets/empty_model_list.dart';
import 'package:flutter_llm/presentation/widgets/local_model_tile.dart';

final class ModelListPage extends StatelessWidget {
  const ModelListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ModelListBloc>()..add(LoadLocalModels()),
      child: const _ModelListView(),
    );
  }
}

final class _ModelListView extends StatelessWidget {
  const _ModelListView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DownloadManagerBloc, DownloadManagerState>(
      listenWhen: (prev, curr) {
        for (final entry in curr.tasks.entries) {
          final prevTask = prev.tasks[entry.key];
          if (entry.value.status == DownloadStatus.completed &&
              prevTask?.status != DownloadStatus.completed) {
            return true;
          }
        }
        return false;
      },
      listener: (context, state) {
        context.read<ModelListBloc>().add(LoadLocalModels());
      },
      child: Scaffold(
        appBar: AppBar(title: const Text(Constants.appName)),
        body: Column(
          children: [
            BlocBuilder<DownloadManagerBloc, DownloadManagerState>(
              builder: (context, downloadState) {
                final active = downloadState.tasks.entries
                    .where(
                        (e) => e.value.status == DownloadStatus.downloading)
                    .toList();
                if (active.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: active
                      .map(
                        (e) => DownloadProgressTile(
                          task: e.value,
                          onCancel: () => context
                              .read<DownloadManagerBloc>()
                              .add(CancelDownload(e.key)),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<ModelListBloc, ModelListState>(
                builder: (context, state) => switch (state) {
                  ModelListLoading() || ModelListInitial() =>
                    const Center(child: CircularProgressIndicator()),
                  ModelListError(:final error) =>
                    Center(child: Text(error)),
                  ModelListLoaded(:final models) when models.isEmpty =>
                    EmptyModelList(
                        onSearch: () => _openSearch(context)),
                  ModelListLoaded(:final models) => RefreshIndicator(
                      onRefresh: () async => context
                          .read<ModelListBloc>()
                          .add(LoadLocalModels()),
                      child: ListView.builder(
                        itemCount: models.length,
                        itemBuilder: (context, index) {
                          final model = models[index];
                          return LocalModelTile(
                            model: model,
                            onTap: () => Navigator.of(context).pushNamed(
                              AppRoutes.loading,
                              arguments: model.path,
                            ),
                            onDelete: () => context
                                .read<ModelListBloc>()
                                .add(DeleteLocalModel(model.path)),
                          );
                        },
                      ),
                    ),
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openSearch(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _openSearch(BuildContext context) async {
    await Navigator.of(context).pushNamed(AppRoutes.search);
    if (context.mounted) {
      context.read<ModelListBloc>().add(LoadLocalModels());
    }
  }
}
