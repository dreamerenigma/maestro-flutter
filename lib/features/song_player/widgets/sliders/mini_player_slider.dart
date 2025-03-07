import 'package:flutter/material.dart';
import '../../../../utils/constants/app_colors.dart';

class MiniPlayerSlider extends StatefulWidget {
  const MiniPlayerSlider({super.key});

  @override
  MiniPlayerSliderState createState() => MiniPlayerSliderState();
}

class MiniPlayerSliderState extends State<MiniPlayerSlider> {
  double _sliderValue = 0.4;
  late FocusNode _focusNode;
  final double _maxDuration = 3 * 60 + 7.01;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  String _formatTime(double seconds) {
    int minutes = (seconds / 60).floor();
    int secs = (seconds % 60).toInt();
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Center(
        child: Focus(
          focusNode: _focusNode,
          onFocusChange: (hasFocus) {
            setState(() {});
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatTime(0),
                    style: TextStyle(color: AppColors.white),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: _focusNode.hasFocus ? AppColors.primary : AppColors.primary,
                        inactiveTrackColor: AppColors.grey,
                        thumbColor: _focusNode.hasFocus ? AppColors.primary : AppColors.primary,
                        thumbShape: _focusNode.hasFocus ? RoundSliderThumbShape(enabledThumbRadius: 14) : RoundSliderThumbShape(enabledThumbRadius: 8),
                        trackHeight: 2.0,
                      ),
                      child: Slider(
                        value: _sliderValue,
                        min: 0,
                        max: _maxDuration,
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Text(_formatTime(_maxDuration), style: TextStyle(color: AppColors.white)),
                  SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(
                      Icons.volume_up,
                      color: AppColors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
