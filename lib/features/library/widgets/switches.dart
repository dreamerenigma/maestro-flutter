import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/app_colors.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final double switchWidth;
  final double switchHeight;
  final double thumbSize;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = AppColors.blue,
    this.inactiveColor = AppColors.grey,
    this.switchWidth = 39.0,
    this.switchHeight = 16.0,
    this.thumbSize = 21.0,
  });

  @override
  CustomSwitchState createState() => CustomSwitchState();
}

class CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: Container(
        width: widget.switchWidth,
        height: widget.switchHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.switchHeight / 2),
          color: widget.value ? widget.activeColor : widget.inactiveColor,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: widget.thumbSize,
                height: widget.thumbSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.isDarkMode ? AppColors.white : AppColors.purple,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withAlpha((0.3 * 255).toInt()),
                      spreadRadius: 1,
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -((widget.thumbSize - widget.switchHeight) / 2),
              left: widget.value ? widget.switchWidth - widget.thumbSize : 0,
              child: Container(
                width: widget.thumbSize,
                height: widget.thumbSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.isDarkMode ? AppColors.white : AppColors.purple,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withAlpha((0.3 * 255).toInt()),
                      spreadRadius: 1,
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
