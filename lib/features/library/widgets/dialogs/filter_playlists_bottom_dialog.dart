import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

final storage = GetStorage();
RxString selectedFilterOption = RxString(storage.read('selectedFilterOption') ?? 'allPlaylists');
RxString selectedSortByOption = RxString(storage.read('selectedSortByOption') ?? 'recentlyUpdated');

void showFilterPlaylistsDialog(BuildContext context) {
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
              height: 5,
              width: 40,
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
                    child: Text('Filter', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                    backgroundColor: context.isDarkMode ? AppColors.white : AppColors.darkerGrey,
                    foregroundColor: context.isDarkMode ? AppColors.buttonDarkGrey : AppColors.lightGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    side: BorderSide.none,
                  ),
                  child: Text('Save', style: TextStyle(fontSize: AppSizes.fontSizeMd, color: context.isDarkMode ? AppColors.black : AppColors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Filter', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.normal, color: AppColors.grey))),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterOption(text: 'All playlists'),
              FilterOption(text: 'Owned playlists'),
              FilterOption(text: 'Liked playlists'),
            ],
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Sort by', style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.normal, color: AppColors.grey))),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SortOption(text: 'Recently updated'),
              SortOption(text: 'Recently added'),
              SortOption(text: 'Title'),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );
    },
  );
}

class FilterOption extends StatelessWidget {
  final String text;

  const FilterOption({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final filterMap = {
      'All playlists': 'allPlaylists',
      'Owned playlists': 'ownedPlaylists',
      'Liked playlists': 'likedPlaylists',
    };

    return InkWell(
      onTap: () {
        selectedFilterOption.value = filterMap[text]!;
        storage.write('selectedFilterOption', selectedFilterOption.value);
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(fontSize: AppSizes.fontSizeMd)),
            Obx(() {
              return selectedFilterOption.value == filterMap[text]
                ? Icon(Icons.check_circle, size: AppSizes.iconLg, color: context.isDarkMode ? AppColors.white : AppColors.black)
                : Container();
            }),
          ],
        ),
      ),
    );
  }
}

class SortOption extends StatelessWidget {
  final String text;

  const SortOption({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final sortMap = {
      'Recently updated': 'recentlyUpdated',
      'Recently added': 'recentlyAdded',
      'Title': 'title',
    };

    return InkWell(
      onTap: () {
        selectedSortByOption.value = sortMap[text]!;
        storage.write('selectedSortByOption', selectedSortByOption.value);
      },
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 14, bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: TextStyle(fontSize: AppSizes.fontSizeMd)),
            Obx(() {
              return selectedSortByOption.value == sortMap[text]
                ? Icon(Icons.check_circle, size: AppSizes.iconLg, color: context.isDarkMode ? AppColors.white : AppColors.black)
                : Container();
            }),
          ],
        ),
      ),
    );
  }
}
