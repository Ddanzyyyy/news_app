import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class NewsWebView extends StatefulWidget {
  final String url;
  const NewsWebView({super.key, required this.url});

  @override
  State<NewsWebView> createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  late final WebViewController _controller;
  bool isLoading = true;
  double loadingProgress = 0.0;
  String pageTitle = "";
  late Timer _timer;
  late String _currentDateTime;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _updateDateTime();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateDateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateDateTime() {
    final now = DateTime.now();
    setState(() {
      _currentDateTime = DateFormat('MMM d, y • HH:mm').format(now);
    });
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
              loadingProgress = 0.0;
            });
          },
          onProgress: (int progress) {
            setState(() {
              loadingProgress = progress / 100;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              isLoading = false;
            });
            final title = await _controller.getTitle();
            setState(() {
              pageTitle = title ?? "";
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _shareContent() async {
    final url = await _controller.currentUrl();
    final title = await _controller.getTitle();
    
    if (url != null) {
      await Share.share(
        '${title ?? 'Check out this article'}\n$url',
        subject: title,
      );
    }
  }

  Future<void> _openInBrowser() async {
    final url = await _controller.currentUrl();
    if (url != null) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    }
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.open_in_browser, color: Colors.grey[800]),
              title: Text(
                'Buka di Browser',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _openInBrowser();
              },
            ),
            ListTile(
              leading: Icon(Icons.share_outlined, color: Colors.grey[800]),
              title: Text(
                'Share',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _shareContent();
              },
            ),
            ListTile(
              leading: Icon(Icons.refresh, color: Colors.grey[800]),
              title: Text(
                'Refresh',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _controller.reload();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.grey[850]),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Breaking News',
            style: GoogleFonts.inter(
              color: Colors.grey[850],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _currentDateTime,
            style: GoogleFonts.inter(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_horiz, color: Colors.grey[850]),
          onPressed: _showMoreOptions,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Column(
          children: [
            if (isLoading)
              LinearProgressIndicator(
                value: loadingProgress,
                backgroundColor: Colors.grey[100],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ],
    );
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }
}