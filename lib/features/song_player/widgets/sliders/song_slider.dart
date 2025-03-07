import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const CustomSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        double newValue = (value + details.primaryDelta! / context.size!.width) * (max - min);
        newValue = newValue.clamp(min, max);
        onChanged(newValue);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 3,
        decoration: BoxDecoration(
          color: inactiveColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: (value - min) / (max - min) * MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Positioned(
              left: (value - min) / (max - min) * MediaQuery.of(context).size.width * 0.9 - 10,
              top: -5,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
