import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:maestro/utils/constants/app_colors.dart';
import '../../../../generated/l10n/l10n.dart';
import '../../../../utils/constants/app_vectors.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  bool isConnected = true;
  final GetStorage _storage = GetStorage();

  @override
  void initState() {
    super.initState();
    isConnected = _storage.read('isConnected') ?? true;
    _checkInternetConnection();

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      setState(() {
        isConnected = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _checkInternetConnection() async {
    bool hasConnection;
    try {
      final result = await InternetAddress.lookup('google.com');
      hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      hasConnection = false;
    }
    setState(() {
      isConnected = hasConnection;
    });
  }

  @override
  Widget build(BuildContext context) {
    final availableItemsCount = isConnected ? 5 : 4;
    final safeSelectedIndex = widget.selectedIndex >= availableItemsCount ? availableItemsCount - 1 : widget.selectedIndex;

    return Container(
      color: context.isDarkMode ? AppColors.blackGrey : AppColors.darkerGrey,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
          ),
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.youngNight : AppColors.white,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              _buildBottomNavigationBarItem(
                context,
                activeIconData: Icons.home,
                inactiveIconData: Icons.home_outlined,
                label: S.of(context).home,
                index: 0,
              ),
              _buildBottomNavigationBarItem(
                context,
                activeSvgPath: AppVectors.feedOutlined,
                inactiveSvgPath: AppVectors.feedInlined,
                label: S.of(context).feed,
                index: 1,
              ),
              _buildBottomNavigationBarItem(
                context,
                activeSvgPath: AppVectors.searchOutlined,
                inactiveSvgPath: AppVectors.searchInline,
                label: S.of(context).search,
                index: 2,
              ),
              _buildBottomNavigationBarItem(
                context,
                activeIconData: FluentIcons.library_20_filled,
                inactiveIconData: FluentIcons.library_20_regular,
                label: S.of(context).library,
                index: 3,
              ),
              if (isConnected)
                _buildBottomNavigationBarItem(
                  context,
                  activeIconData: FluentIcons.music_note_2_20_filled,
                  inactiveIconData: FluentIcons.music_note_2_20_regular,
                  label: S.of(context).upgradeNav,
                  index: 4,
                ),
            ],
            currentIndex: safeSelectedIndex,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: context.isDarkMode ? AppColors.white : AppColors.black,
            onTap: widget.onItemTapped,
            selectedFontSize: 12,
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    BuildContext context, {
      IconData? activeIconData,
      IconData? inactiveIconData,
      String? activeSvgPath,
      String? inactiveSvgPath,
      required String label,
      required int index,
      double activeIconSize = 26.0,
      double inactiveIconSize = 26.0,
    }) {
    bool isSelected = widget.selectedIndex == index;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    const Color selectedColor = AppColors.primary;
    final Color unselectedColor = isDarkMode ? AppColors.white : AppColors.black;

    Widget iconWidget;
    if (activeSvgPath != null && inactiveSvgPath != null) {
      iconWidget = SvgPicture.asset(
        isSelected ? activeSvgPath : inactiveSvgPath,
        colorFilter: ColorFilter.mode(
          isSelected ? selectedColor : unselectedColor,
          BlendMode.srcIn,
        ),
        width: isSelected ? activeIconSize : inactiveIconSize,
        height: isSelected ? activeIconSize : inactiveIconSize,
      );
    } else {
      iconWidget = Icon(
        isSelected ? activeIconData : inactiveIconData,
        color: isSelected ? selectedColor : unselectedColor,
        size: isSelected ? activeIconSize : inactiveIconSize,
      );
    }

    return BottomNavigationBarItem(
      icon: Tooltip(
        richMessage: TextSpan(text: label, style: TextStyle(color: isDarkMode ? AppColors.white : AppColors.black)),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.red : AppColors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary.withAlpha((0.2 * 255).toInt()) : AppColors.transparent,
            borderRadius: BorderRadius.circular(15),
            boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.black.withAlpha((0.2 * 255).toInt()),
                  offset: Offset(0, 0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : [],
          ),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
          child: iconWidget,
        ),
      ),
      label: label,
      tooltip: '',
    );
  }
}
