import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/app_sizes.dart';
import '../../../../utils/constants/app_colors.dart';

void showCastToDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return _CastToDialog();
    },
  );
}

class _CastToDialog extends StatefulWidget {
  @override
  __CastToDialogState createState() => __CastToDialogState();
}

class __CastToDialogState extends State<_CastToDialog> {
  double _progress = 0.0;
  late Timer _timer;
  bool _isSearching = true;
  bool _isHalfProgress = false;
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.01;
      });

      if (_progress >= 0.5 && !_isHalfProgress) {
        setState(() {
          _isHalfProgress = true;
        });
      }

      if (_progress >= 1.0) {
        _timer.cancel();
        setState(() {
          _isSearching = false;
          _isDone = true;
        });
      }
    });

    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.youngNight : AppColors.lightBackground,
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 16),
      title: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 12),
            child: Text(_isDone ? 'No devices available' : 'Cast to', style: const TextStyle(fontSize: AppSizes.fontSizeBg)),
          ),
          Positioned(
            right: 0,
            top: 5,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: _isSearching,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: const Text('Looking for devices...'),
            ),
          ),
          if (_isHalfProgress) Row(
            children: [
              const Icon(Icons.wifi),
              const SizedBox(width: 30),
              Expanded(
                child: Text('Make sure the other device is on the same WI-FI network as this phone', style: TextStyle(fontSize: AppSizes.fontSizeSm)),
              ),
            ],
          ),

          if (!_isSearching && !_isDone) const SizedBox(height: 30),

          if (!_isDone) LinearProgressIndicator(
            value: _progress,
            backgroundColor: AppColors.darkerGrey.withAlpha((0.3 * 255).toInt()),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),

          if (!_isSearching && _isDone) Padding(
            padding: const EdgeInsets.only(left: 53, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {},
                  splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                  highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
                  child: Text(
                    'Learn more',
                    style: TextStyle(
                      fontSize: AppSizes.fontSizeSm,
                      fontWeight: FontWeight.normal,
                      color: AppColors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.isDarkMode ? AppColors.darkGrey : AppColors.lightGrey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      side: BorderSide.none,
                      elevation: 0,
                    ),
                    child: const Text('Ок'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
