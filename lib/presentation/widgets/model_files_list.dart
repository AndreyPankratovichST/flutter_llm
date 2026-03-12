import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_llm/domain/entities/model_file.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_bloc.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_event.dart';
import 'package:flutter_llm/presentation/blocs/download_manager/download_manager_state.dart';
import 'package:flutter_llm/presentation/utils/app_dimens.dart';
import 'package:flutter_llm/presentation/utils/constants.dart';
import 'package:flutter_llm/presentation/widgets/model_file_tile.dart';

class ModelFilesList extends StatelessWidget {
  const ModelFilesList({
    required this.isTextGeneration,
    required this.loadingFiles,
    required this.files,
    required this.modelId,
    super.key,
  });

  final bool isTextGeneration;
  final bool loadingFiles;
  final List<ModelFile>? files;
  final String modelId;

  @override
  Widget build(BuildContext context) {
    if (!isTextGeneration) {
      return _buildComingSoon(context);
    }
    if (loadingFiles) {
      return _buildLoader();
    }
    final list = files;
    if (list == null || list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppDimens.spacingLg),
        child: Text(Constants.noFilesFound),
      );
    }
    return BlocBuilder<DownloadManagerBloc, DownloadManagerState>(
      builder: (context, downloadState) {
        return Column(
          children: list
              .map(
                (f) => ModelFileTile(
                  file: f,
                  isDownloading: downloadState.isDownloading(f.filename),
                  downloadProgress: downloadState.progressFor(f.filename),
                  isDownloadDisabled: downloadState.hasActiveDownloads(),
                  downloadStatus: downloadState.tasks[f.filename]?.status,
                  onDownload: () => context
                      .read<DownloadManagerBloc>()
                      .add(StartDownload(
                        modelId: modelId,
                        filename: f.filename,
                      )),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildComingSoon(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: AppDimens.indicatorSize,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(width: AppDimens.spacingSm),
          Text(Constants.comingSoon, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.all(AppDimens.spacingLg),
      child: Center(
        child: SizedBox(
          width: AppDimens.indicatorSize,
          height: AppDimens.indicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: AppDimens.indicatorStroke,
          ),
        ),
      ),
    );
  }
}
