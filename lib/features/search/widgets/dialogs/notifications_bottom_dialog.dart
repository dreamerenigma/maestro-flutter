import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

final storage = GetStorage();
RxString selectedNotificationsOption = RxString(storage.read('selectedNotificationsOption') ?? 'personalised');

void showNotificationsDialog(BuildContext context) {
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
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 4,
              width: 38,
              decoration: BoxDecoration(color: context.isDarkMode ? AppColors.white : AppColors.black, borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.only(top: 10, bottom: 6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  height: 36,
                  child: CircleAvatar(
                    backgroundColor: AppColors.darkGrey,
                    child: IconButton(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: const Icon(Icons.close, color: AppColors.white, size: 22),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Notifications', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationsOption(text: 'New releases'),
              NotificationsOption(text: 'Personalised', subtitle: 'Most relevant based on your listening history'),
              NotificationsOption(text: 'None'),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );
    },
  );
}

class NotificationsOption extends StatelessWidget {
  final String text;
  final String? subtitle;

  const NotificationsOption({super.key, required this.text, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final sortMap = {
      'New releases': 'newReleases',
      'Personalised': 'personalised',
      'None': 'none',
    };

    return InkWell(
      onTap: () {
        selectedNotificationsOption.value = sortMap[text]!;
        storage.write('selectedNotificationsOption', selectedNotificationsOption.value);
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: TextStyle(fontSize: 17)),
                if (subtitle != null) Text(subtitle!, style: TextStyle(fontSize: 14)),
              ],
            ),
            Obx(() {
              return selectedNotificationsOption.value == sortMap[text]
                ? Icon(Icons.check_circle, size: AppSizes.iconLg, color: context.isDarkMode ? AppColors.white : AppColors.black)
                : Container();
            }),
          ],
        ),
      ),
    );
  }
}
