import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';

showAddYourLinksDialog(BuildContext context, Function(String webOrEmail, String title) onLinkAdded) {
  TextEditingController webOrEmailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  bool hasWebOrEmailError = false;
  String errorMessage = '';

  void validateWebOrEmail() {
    String inputText = webOrEmailController.text;

    if (inputText.isEmpty) {
      hasWebOrEmailError = true;
      errorMessage = 'Enter a web or email address';
    }

    else if (!RegExp(r"^(http|https)://[^\s]+$").hasMatch(inputText) &&
        !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(inputText)) {
      hasWebOrEmailError = true;
      errorMessage = 'This URL or email is invalid';
    } else {
      hasWebOrEmailError = false;
      errorMessage = '';
    }
  }

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
                        child: Text('Add link', style: TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextSelectionTheme(
                          data: TextSelectionThemeData(
                            cursorColor: hasWebOrEmailError ? AppColors.red : AppColors.primary,
                            selectionColor: hasWebOrEmailError ? AppColors.red : AppColors.primary.withAlpha((0.3 * 255).toInt()),
                            selectionHandleColor: hasWebOrEmailError ? AppColors.red : AppColors.primary,
                          ),
                          child: SizedBox(
                            height: 70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: webOrEmailController,
                                  decoration: InputDecoration(
                                    hintText: 'Web or email address',
                                    hintStyle: const TextStyle(color: AppColors.darkerGrey, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: hasWebOrEmailError ? AppColors.red : AppColors.darkerGrey.withAlpha((0.5 * 255).toInt()), width: 1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: hasWebOrEmailError ? AppColors.red : AppColors.primary, width: 1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200),
                                  onChanged: (text) {
                                    setState(() {
                                      validateWebOrEmail();
                                    });
                                  },
                                ),
                                if (hasWebOrEmailError)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(errorMessage, style: TextStyle(color: AppColors.red, fontSize: AppSizes.fontSizeSm, height: 0.3)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: hasWebOrEmailError,
                          child: SizedBox(height: 16),
                        ),
                        TextSelectionTheme(
                          data: TextSelectionThemeData(
                            cursorColor: AppColors.primary,
                            selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
                            selectionHandleColor: AppColors.primary,
                          ),
                          child: SizedBox(
                            height: 70,
                            child: TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                hintText: 'Short title',
                                hintStyle: const TextStyle(color: AppColors.darkerGrey, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.darkerGrey.withAlpha((0.5* 255).toInt()), width: 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.primary, width: 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              style: TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            String webOrEmail = webOrEmailController.text;
                            String title = titleController.text;
                            onLinkAdded(webOrEmail, title);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            backgroundColor: context.isDarkMode ? AppColors.darkGrey : AppColors.grey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: AppColors.darkerGrey.withAlpha((0.5* 255).toInt()), width: 1),
                            elevation: 4,
                            shadowColor: AppColors.black.withAlpha((0.3 * 255).toInt()),
                          ),
                          child: const Text('Add link'),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            backgroundColor: context.isDarkMode ? AppColors.darkGrey : AppColors.grey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: AppColors.darkerGrey.withAlpha((0.5* 255).toInt()), width: 1),
                            elevation: 4,
                            shadowColor: AppColors.black.withAlpha((0.3 * 255).toInt()),
                          ),
                          child: const Text('Add support link'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (keyboardVisible) ...[
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ],
          );
        }
      );
    }
  );
}
