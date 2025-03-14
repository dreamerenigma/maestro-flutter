import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';

class CustomSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final double thumbSize;

  const CustomSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.activeColor,
    required this.inactiveColor,
    required this.thumbSize,
  });

  @override
  CustomSliderState createState() => CustomSliderState();
}

class CustomSliderState extends State<CustomSlider> {
  late double _value;
  late double _sliderWidth;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    double newValue = (details.localPosition.dx / _sliderWidth) * (widget.max - widget.min);
    newValue = newValue.clamp(widget.min, widget.max);
    setState(() {
      _value = newValue;
    });
    widget.onChanged(_value);
  }

  @override
Widget build(BuildContext context) {
  return GestureDetector(
    onHorizontalDragUpdate: _onDragUpdate,
    onHorizontalDragEnd: (details) {
      widget.onChanged(_value);
    },
    child: InkWell(
      onTap: () {},
      child: Builder(
        builder: (context) {
          _sliderWidth = MediaQuery.of(context).size.width * 0.9;
          return Container(
            width: _sliderWidth,
            height: 3,
            decoration: BoxDecoration(
              color: widget.inactiveColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: (_value - widget.min) / (widget.max - widget.min) * _sliderWidth,
                      decoration: BoxDecoration(
                        color: widget.activeColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: (_value - widget.min) / (widget.max - widget.min) * _sliderWidth - widget.thumbSize / 1,
                  top: -widget.thumbSize / 1,
                  child: InkWell(
                    splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                    borderRadius: BorderRadius.circular(26),
                    onTap: () {},
                    child: Container(
                      width: widget.thumbSize * 2.1,
                      height: widget.thumbSize * 2.1,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Container(
                          width: widget.thumbSize,
                          height: widget.thumbSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
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
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
}
