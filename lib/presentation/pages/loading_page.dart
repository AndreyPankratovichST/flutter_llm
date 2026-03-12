import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_llm/di/app_di.dart';
import 'package:flutter_llm/presentation/blocs/model_loader/model_loader_bloc.dart';
import 'package:flutter_llm/presentation/blocs/model_loader/model_loader_event.dart';
import 'package:flutter_llm/presentation/blocs/model_loader/model_loader_state.dart';
import 'package:flutter_llm/presentation/router/app_routes.dart';
import 'package:flutter_llm/presentation/utils/app_dimens.dart';
import 'package:flutter_llm/presentation/utils/constants.dart';

final class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modelPath = ModalRoute.of(context)!.settings.arguments! as String;

    return BlocProvider(
      create: (_) => getIt<ModelLoaderBloc>()..add(LoadModel(modelPath)),
      child: const _LoadingView(),
    );
  }
}

final class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ModelLoaderBloc, ModelLoaderState>(
      listener: (context, state) {
        if (state is ModelLoaded) {
          Navigator.of(
            context,
          ).pushReplacementNamed(AppRoutes.chat, arguments: state.modelInfo);
        }
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spacingXxl),
            child: BlocBuilder<ModelLoaderBloc, ModelLoaderState>(
              builder: (context, state) {
                if (state is ModelLoadError) {
                  return _buildError(context, state.error);
                }
                return _buildLoading(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: AppDimens.spacingXl),
        Text(Constants.loadingModel, style: theme.textTheme.titleMedium),
      ],
    );
  }

  Widget _buildError(BuildContext context, String error) {
    final theme = Theme.of(context);
    final modelPath = ModalRoute.of(context)?.settings.arguments as String?;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          size: AppDimens.iconSizeLg,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: AppDimens.spacingLg),
        Text(Constants.failedToLoadModel, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppDimens.spacingSm),
        Text(
          error,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.spacingXl),
        if (modelPath != null)
          FilledButton(
            onPressed: () =>
                context.read<ModelLoaderBloc>().add(LoadModel(modelPath)),
            child: const Text(Constants.retry),
          ),
      ],
    );
  }
}
