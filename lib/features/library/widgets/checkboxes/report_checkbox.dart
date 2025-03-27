import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';

class ReportCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color activeColor;
  final Color checkColor;
  final String label;

  const ReportCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.activeColor,
    required this.checkColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          children: [
            GestureDetector(
              onTap: () => onChanged(!value),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: value ? activeColor : AppColors.darkerGrey, width: 1.5),
                  borderRadius: BorderRadius.circular(4),
                  color: value ? activeColor : AppColors.transparent,
                ),
                child: value ? Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Icon(Icons.check_rounded, color: checkColor, size: 18),
                ) : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                style: TextStyle(fontSize: 15, fontFamily: 'Roboto', fontWeight: FontWeight.normal),
                maxLines: null,
                textAlign: TextAlign.left,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        );
      },
    );
  }
}
