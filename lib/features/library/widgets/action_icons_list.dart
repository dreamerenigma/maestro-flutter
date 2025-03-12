import 'package:flutter/material.dart';
import '../../../../../utils/constants/app_colors.dart';

class ActionIconsList extends StatelessWidget {
  final List<Map<String, dynamic>> itemsData;


  const ActionIconsList({super.key, required this.itemsData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemsData.length,
        itemBuilder: (context, index) {
          Color containerColor = (index == 3 || index == 4) ? AppColors.whatsApp : AppColors.darkGrey;

          BoxDecoration outerDecoration = BoxDecoration(
            color: containerColor,
            shape: BoxShape.circle,
            border: index == 4 ? Border.all(color: AppColors.whatsApp, width: 2) : null,
          );

          BoxDecoration innerDecoration = BoxDecoration(
            color: containerColor,
            shape: BoxShape.circle,
            border: index == 4 ? Border.all(color: AppColors.backgroundColor, width: 2) : null,
          );

          return InkWell(
            onTap: itemsData[index]['onTap'],
            splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: outerDecoration,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: innerDecoration,
                      child: Icon(itemsData[index]['icon'], color: AppColors.white, size: 32),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    itemsData[index]['text'],
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
