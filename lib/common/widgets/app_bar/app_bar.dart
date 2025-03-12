import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/popups/dialogs.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final List<Widget>? actions;
  final bool hideBack;
  final bool centerTitle;
  final bool showCloseIcon;
  final String? saveButtonText;
  final VoidCallback? onSavePressed;
  final VoidCallback? onBackPressed;
  final bool rotateIcon;
  final bool removeIconContainer;

  const BasicAppBar({
    this.title,
    this.hideBack = false,
    this.action,
    this.actions,
    this.centerTitle = true,
    this.showCloseIcon = false,
    this.saveButtonText,
    this.onSavePressed,
    this.onBackPressed,
    this.rotateIcon = false,
    this.removeIconContainer = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: AppBar(
          backgroundColor: context.isDarkMode ? AppColors.backgroundColor : AppColors.white,
          elevation: 0,
          centerTitle: centerTitle,
          title: title ?? const Text(''),
          actions: [
            if (saveButtonText != null && onSavePressed != null)
              Row(
                children: [
                  if (actions != null) ...actions!,
                  if (action != null) action!,
                  _buildSaveButton(context),
                ],
              ),
            if (saveButtonText == null || onSavePressed == null) ...[
              if (actions != null) ...actions!,
              if (action != null) action!,
            ],
          ],
          leading: hideBack
            ? Container()
            : IconButton(
              splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
              highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
              onPressed: () {
                if (onBackPressed != null) {
                  onBackPressed!();
                } else {
                  Navigator.pop(context);
                }
              },
              icon: removeIconContainer
                ? Transform.rotate(
                    angle: rotateIcon ? -3.14159 / 2 : 0,
                    child: Padding(
                      padding: EdgeInsets.only(right: showCloseIcon ? 0 : 2),
                      child: Icon(
                        showCloseIcon ? Icons.close : Icons.arrow_back_ios_new,
                        size: showCloseIcon ? 24 : 20,
                        color: context.isDarkMode ? AppColors.white : AppColors.black,
                      ),
                    ),
                  )
                : Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: context.isDarkMode ? AppColors.white.withAlpha((0.1 * 255).toInt()) : AppColors.black.withAlpha((0.08 * 255).toInt()),
                      shape: BoxShape.circle,
                    ),
                    child: Transform.rotate(
                      angle: rotateIcon ? -3.14159 / 2 : 0,
                      child: Padding(
                        padding: EdgeInsets.only(right: showCloseIcon ? 0 : 2),
                        child: Icon(
                          showCloseIcon ? Icons.close : Icons.arrow_back_ios_new,
                          size: showCloseIcon ? 24 : 20,
                          color: context.isDarkMode ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
          titleSpacing: hideBack ? 0.0 : NavigationToolbar.kMiddleSpacing,
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 12),
      child: SizedBox(
        height: 35,
        child: ElevatedButton(
          onPressed: () async {
            Dialogs.showProgressBarDialog(context, title: '', message: 'Saving');

            onSavePressed?.call();

            await Future.delayed(Duration(seconds: 1));

            Navigator.pop(context);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: context.isDarkMode ? AppColors.white : AppColors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            side: BorderSide.none,
            elevation: 0,
          ),
          child: Text(
            saveButtonText!,
            style: TextStyle(color: context.isDarkMode ? AppColors.black : AppColors.white),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

