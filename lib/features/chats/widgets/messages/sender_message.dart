import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../models/message_model.dart';

class SenderMessage extends StatelessWidget {
  final MessageModel message;

  const SenderMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            padding: EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
            decoration: BoxDecoration(color: AppColors.darkGrey, borderRadius: BorderRadius.circular(15)),
            child: Text(
              message.message,
              textAlign: TextAlign.left,
              style: TextStyle(color: AppColors.white, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200),
            ),
          ),
          Text(
            Formatter.formatTimeAgo(message.sent),
            textAlign: TextAlign.left,
            style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeLm, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
