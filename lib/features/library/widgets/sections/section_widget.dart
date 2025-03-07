import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class SectionWidget extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? trailingWidget;
  final VoidCallback? onTap;

  const SectionWidget({
    super.key,
    required this.title,
    this.content,
    this.trailingWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
        highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(title, style: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, letterSpacing: -0.5))),
                  SizedBox(width: 8),
                  if (trailingWidget != null) trailingWidget!,
                ],
              ),
              if (content != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(content!, style: const TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.buttonGrey, letterSpacing: -0.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

