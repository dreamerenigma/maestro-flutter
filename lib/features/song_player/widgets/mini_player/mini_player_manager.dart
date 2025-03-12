import 'package:flutter/material.dart';
import 'mini_player_widget.dart';

class MiniPlayerManager extends StatefulWidget {
  final Widget child;
  final bool hideMiniPlayerOnSplash;

  const MiniPlayerManager({super.key, required this.child, required this.hideMiniPlayerOnSplash});

  @override
  State<MiniPlayerManager> createState() => _MiniPlayerManagerState();

  static void showMiniPlayer(BuildContext context) {
    final state = context.findAncestorStateOfType<_MiniPlayerManagerState>();
    state?.showMiniPlayer();
  }

  static void hideMiniPlayer(BuildContext context) {
    final state = context.findAncestorStateOfType<_MiniPlayerManagerState>();
    state?.hideMiniPlayer();
  }
}

class _MiniPlayerManagerState extends State<MiniPlayerManager> {
  bool _isMiniPlayerVisible = true;

  void showMiniPlayer() {
    setState(() {
      _isMiniPlayerVisible = true;
    });
  }

  void hideMiniPlayer() {
    setState(() {
      _isMiniPlayerVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hideMiniPlayerOnSplash && _isMiniPlayerVisible) {
      hideMiniPlayer();
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,
          if (_isMiniPlayerVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MiniPlayerWidget(onItemTapped: (int) {}),
            ),
        ],
      ),
    );
  }
}

