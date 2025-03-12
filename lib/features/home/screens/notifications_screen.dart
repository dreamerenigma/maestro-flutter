import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jam_icons/jam_icons.dart';
import '../../../common/widgets/app_bar/app_bar.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../routes/custom_page_route.dart';
import '../widgets/dialogs/notification_bottom_dialog.dart';
import '../widgets/nav_bar/bottom_nav_bar.dart';
import 'home_screen.dart';

class NotificationsScreen extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const NotificationsScreen({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final GetStorage _storageBox = GetStorage();
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = _storageBox.read('selectedNotificationOption') ?? 'Show all notifications';
  }

  Future<void> _openNotificationDialog() async {
    final newOption = await showNotificationDialog(context, selectedOption);
    if (newOption != null && newOption != selectedOption) {
      setState(() {
        selectedOption = newOption;
      });
      _storageBox.write('selectedNotificationOption', newOption);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(S.of(context).notifications, style: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _openNotificationDialog,
            icon: const Icon(JamIcons.settingsAlt, size: 23),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, size: 23),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildSection(S.of(context).nothingHappenedYet, S.of(context).nothingHappenedYetSubtitle),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: widget.selectedIndex,
        onItemTapped: (index) {
          Navigator.pushReplacement(context, createPageRoute(HomeScreen(initialIndex: index)));
        },
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return InkWell(
      onTap: () {},
      splashColor: AppColors.darkGrey.withAlpha((0.3 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.3 * 255).toInt()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: AppSizes.fontSizeBg, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                content,
                style: const TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.darkerGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

