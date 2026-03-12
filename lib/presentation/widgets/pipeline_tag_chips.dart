import 'package:flutter/material.dart';
import 'package:flutter_llm/domain/entities/pipeline_tag.dart';
import 'package:flutter_llm/presentation/utils/app_dimens.dart';

class PipelineTagChips extends StatelessWidget {
  const PipelineTagChips({
    required this.selectedTag,
    required this.onTagChanged,
    super.key,
  });

  final PipelineTag selectedTag;
  final ValueChanged<PipelineTag> onTagChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.spacingXxl,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
        itemCount: PipelineTag.values.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: AppDimens.spacingSm),
        itemBuilder: (context, index) {
          final tag = PipelineTag.values[index];
          return ChoiceChip(
            label: Text(tag.displayName),
            selected: selectedTag == tag,
            onSelected: (_) => onTagChanged(tag),
          );
        },
      ),
    );
  }
}
