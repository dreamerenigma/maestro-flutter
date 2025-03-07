import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../utils/constants/app_colors.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  late String _currentUrl;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
    _currentUrl = Uri.parse(widget.url).host;
  }

  @override
  Widget build(BuildContext context) {
    String truncatedUrl = _currentUrl.length > 14 ? '${_currentUrl.substring(0, 14)}...' : _currentUrl;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
          icon: Icon(Icons.close, color: AppColors.white, size: 24),
        ),
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {},
              splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
              highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
              icon: Transform.rotate(
                angle: 90 * 3.14159 / 180,
                child: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.white, size: 22),
              ),
            ),
            IconButton(
              onPressed: () async {},
              splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
              highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
              icon: Icon(LucideIcons.settings2, size: 18, color: AppColors.white),
            ),
            SizedBox(width: 12),
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [AppColors.softGrey, AppColors.softGrey.withAlpha(0)],
                      stops: [0.88, 1],
                    ).createShader(bounds);
                  },
                  child: Text(
                    truncatedUrl.length > 14 ? truncatedUrl.substring(0, 14) : truncatedUrl,
                    style: TextStyle(color: AppColors.softGrey, fontSize: 17),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Text(
                  truncatedUrl.length > 14 ? truncatedUrl.substring(14) : "",
                  style: TextStyle(color: AppColors.softGrey, fontSize: 17),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            splashColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            highlightColor: AppColors.darkGrey.withAlpha((0.4 * 255).toInt()),
            icon: Icon(Icons.share, size: 24),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert_rounded, size: 24),
          ),
        ],
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
