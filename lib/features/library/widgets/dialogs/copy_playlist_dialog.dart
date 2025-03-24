import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../data/services/playlist/playlist_firebase_service.dart';
import '../../../../service_locator.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../switches.dart';

void showCopyPlaylistDialog(BuildContext context, String playlistId) {
  final TextEditingController controller = TextEditingController(text: 'Copy of Untitled Playlist');
  final FocusNode focusNode = FocusNode();
  int currentLength = 0;
  final storage = GetStorage();
  bool isPublic = storage.read('isPublic') ?? false;

  showModalBottomSheet(
    context: context,
    enableDrag: true,
    showDragHandle: false,
    isScrollControlled: true,
    backgroundColor: context.isDarkMode ? AppColors.backgroundColor : AppColors.lightBackground,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

          Future.delayed(Duration.zero, () {
            FocusScope.of(context).requestFocus(focusNode);
            controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
          });

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
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Copy playlist', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String playlistTitle = controller.text;
                        bool playlistPublic = isPublic;

                        var result = await sl<PlaylistFirebaseService>().copyPlaylist(playlistId, playlistTitle, playlistPublic);

                        result.fold(
                          (error) {
                            log('Error: $error');
                            Get.snackbar('Error', error.toString());
                          },
                          (playlistId) async {
                            log('Playlist copy with ID: $playlistId');
                            Navigator.pop(context);
                            Get.snackbar('Success', 'Playlist copy successfully!');
                          },
                        );
                      },
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
              _buildTextField('Playlist title', controller, focusNode: focusNode, maxLength: 50, currentLength: currentLength, setState: setState),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isPublic = !isPublic;
                    });
                    storage.write('isPublic', isPublic);
                  },
                  splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                  highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Make public', style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold)),
                        CustomSwitch(
                          value: isPublic,
                          onChanged: (value) {
                            setState(() {
                              isPublic = value;
                            });
                            storage.write('isPublic', isPublic);
                          },
                          activeColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (keyboardVisible) ...[
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ],
          );
        },
      );
    },
  );
}

Widget _buildTextField(
    String label, 
    TextEditingController controller, {
      required FocusNode focusNode, 
      required int maxLength, 
      required int currentLength, 
      required Function setState
    }) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: AppSizes.fontSizeSm, fontWeight: FontWeight.w200, height: 0.1, letterSpacing: -0.7)),
        TextSelectionTheme(
          data: TextSelectionThemeData(
            cursorColor: AppColors.primary,
            selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
            selectionHandleColor: AppColors.primary,
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            maxLength: maxLength,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.darkGrey)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.white)),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w400),
            textCapitalization: TextCapitalization.sentences,
            onChanged: (text) {
              setState(() {
                currentLength = text.length;
              });
            },
          ),
        ),
      ],
    ),
  );
}
