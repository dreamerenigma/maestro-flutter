import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

void showNewMessageBottomDialog(BuildContext context) {
  final storage = GetStorage();
  RxString selectedOption = RxString(storage.read('selectedOption') ?? 'off');

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
            decoration: BoxDecoration(
              color: context.isDarkMode ? AppColors.white : AppColors.black,
              borderRadius: BorderRadius.circular(10),
            ),
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
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: const Icon(Icons.close, color: AppColors.white, size: 22),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text('New message', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
              ],
            ),
          ),
          SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  selectedOption.value = 'off';
                  storage.write('selectedOption', selectedOption.value);
                },
                splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      Text('Off', style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.normal, letterSpacing: -0.5)),
                      Spacer(),
                      Obx(() => selectedOption.value == 'off' ? Icon(Icons.check_circle) : Container()),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  selectedOption.value = 'fromPeopleIFollow';
                  storage.write('selectedOption', selectedOption.value);
                },
                splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      Text('From people I follow', style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.normal, letterSpacing: -0.5)),
                      Spacer(),
                      Obx(() => selectedOption.value == 'fromPeopleIFollow' ? Icon(Icons.check_circle) : Container()),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  selectedOption.value = 'fromEveryone';
                  storage.write('selectedOption', selectedOption.value);
                },
                splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      Text('From everyone', style: TextStyle(fontSize: AppSizes.fontSizeLg, fontWeight: FontWeight.normal, letterSpacing: -0.5)),
                      Spacer(),
                      Obx(() => selectedOption.value == 'fromEveryone' ? Icon(Icons.check_circle) : Container()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Text(
                  'If you have disabled "Receive messages from anyone" in your inbox settings, you will only ever receive messages and notifications from people you follow.',
                  style: TextStyle(fontSize: AppSizes.fontSizeSm, height: 1.2, letterSpacing: -0.3),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ],
      );
    },
  );
}
