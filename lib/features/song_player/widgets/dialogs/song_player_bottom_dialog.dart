import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../domain/entities/song/song_entity.dart';

void showSongPlayerDialog(BuildContext context, {required SongEntity songEntity}) {
  showModalBottomSheet(
    context: context,
    enableDrag: true,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? AppColors.backgroundColor : AppColors.lightBackground,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.96,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [],
        ),
      );
    },
  );
}
