import 'package:flutter/material.dart';
import 'package:maestro/utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';

class CustomRadioButton extends StatelessWidget {
  final bool selected;
  final String label;
  final VoidCallback onPressed;

  const CustomRadioButton({
    super.key,
    required this.selected,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 12, top: 14, bottom: 14),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selected ? AppColors.white : AppColors.grey, width: 1.7),
              ),
              child: Center(
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: selected ? AppColors.white : AppColors.transparent),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
              child: Text(
                label,
                style: TextStyle(fontSize: AppSizes.fontSizeSm),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
