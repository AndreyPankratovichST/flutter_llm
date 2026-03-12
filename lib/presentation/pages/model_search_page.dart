import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_llm/di/app_di.dart';
import 'package:flutter_llm/domain/entities/download_task.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_bloc.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_state.dart';
import 'package:flutter_llm/presentation/blocs/model_search/model_search_bloc.dart';
import 'package:flutter_llm/presentation/blocs/model_search/model_search_event.dart';
import 'package:flutter_llm/presentation/blocs/model_search/model_search_state.dart';
import 'package:flutter_llm/presentation/utils/app_dimens.dart';
import 'package:flutter_llm/presentation/utils/constants.dart';
import 'package:flutter_llm/presentation/widgets/model_files_list.dart';
import 'package:flutter_llm/presentation/widgets/model_search_card.dart';
import 'package:flutter_llm/presentation/widgets/pipeline_tag_chips.dart';

final class ModelSearchPage extends StatelessWidget {
  const ModelSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ModelSearchBloc>(),
      child: const _ModelSearchView(),
    );
  }
}

final class _ModelSearchView extends StatefulWidget {
  const _ModelSearchView();

  @override
  State<_ModelSearchView> createState() => _ModelSearchViewState();
}

class _ModelSearchViewState extends State<_ModelSearchView> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final trimmed = query.trim();
      if (trimmed.isNotEmpty) {
        context.read<ModelSearchBloc>().add(SearchModels(trimmed));
      }
    });
  }

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(Constants.downloadComplete)),
        );
      },
      child: Scaffold(
        appBar: AppBar(title: const Text(Constants.searchModels)),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimens.spacingLg),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: Constants.searchHint,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(AppDimens.radiusMd),
                  ),
                ),
                autofocus: true,
              ),
            ),
            BlocSelector<ModelSearchBloc, ModelSearchState, ModelSearchState>(
              selector: (state) => state,
              builder: (context, state) => PipelineTagChips(
                selectedTag: state.selectedTag,
                onTagChanged: (tag) =>
                    context.read<ModelSearchBloc>().add(ChangePipelineTag(tag)),
              ),
            ),
            Expanded(
              child: BlocBuilder<ModelSearchBloc, ModelSearchState>(
                builder: (context, state) {
                  if (state.searching) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.error != null) {
                    return Center(child: Text(state.error!));
                  }
                  final results = state.results;
                  if (results == null) {
                    return const SizedBox.shrink();
                  }
                  if (results.isEmpty) {
                    return const Center(
                      child: Text(Constants.noFilesFound),
                    );
                  }
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final model = results[index];
                      final isExpanded =
                          state.expandedModelId == model.id;
                      return ModelSearchCard(
                        model: model,
                        isExpanded: isExpanded,
                        onTap: () => context
                            .read<ModelSearchBloc>()
                            .add(ToggleModelExpansion(model.id)),
                        expandedContent: ModelFilesList(
                          isTextGeneration:
                              state.selectedTag.isTextGeneration,
                          loadingFiles: state.loadingFiles,
                          files: state.files,
                          modelId: model.id,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
