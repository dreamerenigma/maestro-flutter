import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../models/message_model.dart';

class RecipientMessage extends StatelessWidget {
  final MessageModel message;

  const RecipientMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.grey, borderRadius: BorderRadius.circular(15)),
        child: Text(message.message, style: TextStyle(color: AppColors.white, fontSize: AppSizes.fontSizeMd, fontWeight: FontWeight.w200)),
      ),
    );
  }
}

