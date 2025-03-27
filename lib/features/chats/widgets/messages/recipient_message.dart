import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../routes/custom_page_route.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_vectors.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../../search/screens/follow_screen.dart';
import '../../models/message_model.dart';

class RecipientMessage extends StatelessWidget {
  final int initialIndex;
  final MessageModel message;
  final UserEntity user;

  const RecipientMessage({super.key, required this.message, required this.initialIndex, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Ink(
                      decoration: BoxDecoration(
                        color: AppColors.darkGrey,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.darkerGrey.withAlpha((0.2 * 255).toInt()), width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: user.image.isNotEmpty
                          ? CachedNetworkImage(
                            imageUrl: user.image,
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: AppColors.darkGrey,
                              highlightColor: AppColors.steelGrey,
                              child: Container(width: 35, height: 35, decoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle)),
                            ),
                            errorWidget: (context, url, error) => SvgPicture.asset(AppVectors.avatar, width: 22, height: 22),
                          )
                          : SvgPicture.asset(AppVectors.avatar, width: 40, height: 40),
                      ),
                    ),
                    Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, createPageRoute(FollowScreen(initialIndex: initialIndex, user: user)));
                        },
                        splashColor: AppColors.steelGrey.withAlpha((0.2 * 255).toInt()),
                        highlightColor: AppColors.steelGrey.withAlpha((0.2 * 255).toInt()),
                        borderRadius: BorderRadius.circular(40),
                        child: Container(width: 35, height: 35, decoration: BoxDecoration(borderRadius: BorderRadius.circular(40))),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    padding: EdgeInsets.only(left: 14, right: 14, top: 6, bottom: 6),
                    decoration: BoxDecoration(color: AppColors.darkGrey, borderRadius: BorderRadius.circular(12)),
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
            ],
          ),
        ],
      ),
    );
  }
}

