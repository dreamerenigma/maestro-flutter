import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

class CommentsItem extends StatelessWidget {
  final String optionValue;
  final String displayText;
  final RxString selectedOption;
  final void Function() onTap;

  const CommentsItem({
    super.key,
    required this.optionValue,
    required this.displayText,
    required this.selectedOption,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Text(displayText, style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.normal, letterSpacing: -0.5)),
            Spacer(),
            Obx(() => selectedOption.value == optionValue ? Icon(Icons.check_circle) : Container()),
          ],
        ),
      ),
    );
  }
}

void showSortByCommentsBottomDialog(BuildContext context) {
  final storage = GetStorage();
  RxString selectedOption = RxString(storage.read('selectedOption') ?? 'newest');

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? AppColors.backgroundColor : AppColors.lightBackground,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(color: context.isDarkMode ? AppColors.white : AppColors.black, borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.only(top: 10, bottom: 6),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 36,
                  child: CircleAvatar(
                    backgroundColor: AppColors.darkGrey,
                    child: IconButton(
                      icon: Padding(padding: const EdgeInsets.only(bottom: 10), child: const Icon(Icons.close, color: AppColors.white, size: 22)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text('Sort by', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
              ],
            ),
          ),
          SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommentsItem(
                optionValue: 'newest',
                displayText: 'Newest',
                selectedOption: selectedOption,
                onTap: () {
                  selectedOption.value = 'newest';
                  storage.write('selectedOption', selectedOption.value);
                },
              ),
              CommentsItem(
                optionValue: 'oldest',
                displayText: 'Oldest',
                selectedOption: selectedOption,
                onTap: () {
                  selectedOption.value = 'oldest';
                  storage.write('selectedOption', selectedOption.value);
                },
              ),
              CommentsItem(
                optionValue: 'trackTime',
                displayText: 'Track time',
                selectedOption: selectedOption,
                onTap: () {
                  selectedOption.value = 'trackTime';
                  storage.write('selectedOption', selectedOption.value);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      );
    },
  );
}
