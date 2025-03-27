import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../generated/l10n/l10n.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../../utils/formatters/formatter.dart';

class MessageWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const MessageWidget({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final userName = userData['name'] as String?;
    final createdAtTimestamp = userData['createdAt'] as Timestamp?;
    final createdAt = createdAtTimestamp?.toDate();
    String timeAgo = createdAt != null ? Formatter.formatTime(createdAt) : S.of(context).noDateAvailable;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.white, border: Border.all(color: AppColors.darkGrey, width: 1)),
            child: Padding(
              padding: const EdgeInsets.only(right: 2),
              child: const Icon(ZondIcons.music_notes, color: AppColors.black),
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    children: [
                      Text(S.of(context).appName, style: const TextStyle(fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.bold, height: 1)),
                      const SizedBox(width: 6),
                      Icon(FluentIcons.checkmark_starburst_16_filled, color: AppColors.blue, size: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).helloUserMessage(userName ?? S.of(context).noName),
                        style: const TextStyle(fontSize: AppSizes.fontSizeSm, color: AppColors.grey, height: 1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Row(
                      children: [
                        Text('·', style: TextStyle(fontSize: AppSizes.fontSizeMg, color: AppColors.grey, fontWeight: FontWeight.bold, height: 1)),
                        SizedBox(width: 4),
                        Text(timeAgo, style: const TextStyle(fontSize: AppSizes.fontSizeLm, color: AppColors.grey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
