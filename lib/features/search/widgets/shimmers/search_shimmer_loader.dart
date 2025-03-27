import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../utils/constants/app_colors.dart';

class SearchShimmerLoader extends StatelessWidget {
  final int itemCount;

  const SearchShimmerLoader({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.grey.withAlpha((0.2 * 255).toInt()),
                highlightColor: AppColors.grey.withAlpha((0.4 * 255).toInt()),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: AppColors.grey.withAlpha((0.2 * 255).toInt()), borderRadius: BorderRadius.circular(40)),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.grey.withAlpha((0.2 * 255).toInt()),
                      highlightColor: AppColors.grey.withAlpha((0.4 * 255).toInt()),
                      child: Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(color: AppColors.grey.withAlpha((0.2 * 255).toInt()), borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                    SizedBox(height: 5),
                    Shimmer.fromColors(
                      baseColor: AppColors.grey.withAlpha((0.2 * 255).toInt()),
                      highlightColor: AppColors.grey.withAlpha((0.4 * 255).toInt()),
                      child: Container(
                        width: 100,
                        height: 14,
                        decoration: BoxDecoration(color: AppColors.grey.withAlpha((0.2 * 255).toInt()), borderRadius: BorderRadius.circular(4)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Shimmer.fromColors(
                baseColor: AppColors.grey.withAlpha((0.2 * 255).toInt()),
                highlightColor: AppColors.grey.withAlpha((0.4 * 255).toInt()),
                child: Container(
                  width: 60,
                  height: 14,
                  decoration: BoxDecoration(color: AppColors.grey.withAlpha((0.2 * 255).toInt()), borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
