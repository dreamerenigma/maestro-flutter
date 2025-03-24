import 'package:flutter/material.dart';
import 'package:audio_session/audio_session.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/app_vectors.dart';

class DeviceIconButton extends StatefulWidget {
  const DeviceIconButton({super.key});

  @override
  DeviceIconButtonState createState() => DeviceIconButtonState();
}

class DeviceIconButtonState extends State<DeviceIconButton> {
  late AudioSession _audioSession;
  String _audioOutput = "speaker";

  @override
  void initState() {
    super.initState();
    _initAudioSession();
  }

  Future<void> _initAudioSession() async {
    _audioSession = await AudioSession.instance;
    await _audioSession.configure(AudioSessionConfiguration.music());

    _audioSession.setActive(true);

    _audioSession.devicesStream.listen(_onDevicesChanged);
  }

  void _onDevicesChanged(Set<AudioDevice> devices) {
    for (var device in devices) {
      if (device.isOutput) {
        setState(() {
          if (device.type == AudioDeviceType.airPlay) {
            _audioOutput = "headphones";
          } else if (device.type == AudioDeviceType.auxLine) {
            _audioOutput = "speaker";
          } else if (device.type == AudioDeviceType.airPlay) {
            _audioOutput = "bluetooth";
          } else {
            _audioOutput = "other";
          }
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData? icon;
    String? svgIconPath;

    switch (_audioOutput) {
      case "headphones":
        icon = BootstrapIcons.headphones;
        break;
      case "bluetooth":
        icon = BootstrapIcons.bluetooth;
        break;
      case "speaker":
        icon = BootstrapIcons.speaker;
        break;
      default:
        svgIconPath = AppVectors.desktopDevice;
    }

    return IconButton(
      splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
      onPressed: () {},
      icon: svgIconPath != null
        ? SvgPicture.asset(svgIconPath, width: 23, height: 23, colorFilter: ColorFilter.mode(AppColors.buttonGrey, BlendMode.srcIn))
        : Icon(icon, color: AppColors.buttonGrey, size: 23),
    );
  }
}
