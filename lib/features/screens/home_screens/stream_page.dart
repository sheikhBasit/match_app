import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:match_app/common_widgets/user_subscription.dart';
import 'package:match_app/features/screens/ads/interstitial_ad.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class StreamingPage extends StatefulWidget {
  final String channelName;

  const StreamingPage({Key? key, required this.channelName}) : super(key: key);

  @override
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  String _videoUrl = '';
  bool _isLoading = true;
  bool _isError = false;
  bool _isConnected = true;
  String _statusMessage = '';
  Timer? _timer;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _checkConnectivityAndInitializePlayer();
    });

    _timer = Timer.periodic(
        const Duration(seconds: 10), (Timer t) => _checkForUpdates());
    if (!UserSubscription.isSubscribed) InterstitialAdManager.loadAd();

    Future.delayed(const Duration(seconds: 5), () {
    if (!UserSubscription.isSubscribed)  InterstitialAdManager.showAd();
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    _timer?.cancel();
    Wakelock.disable();
    super.dispose();
  }

  Future<void> _fetchStreamingDetails({bool showLoading = true}) async {
    if (showLoading && _isInitialLoading) {
      setState(() {
        _isLoading = true;
        _isError = false;
        _statusMessage = '';
      });
    }

    try {
      final channelSnapshot = await FirebaseFirestore.instance
          .collection(widget.channelName) // Use channel name to fetch data
          .doc(widget.channelName) // Use channel name to fetch data
          .get();

      if (channelSnapshot.exists) {
        final data = channelSnapshot.data() as Map<String, dynamic>;
        if (data['status'] == true) {
          // Check if status is true
          setState(() {
            _videoUrl = data['video_url'] ?? '';
          });
        }
      }

      if (_videoUrl.isEmpty) {
        final defaultSnapshot = await FirebaseFirestore.instance
            .collection('default') // Use the 'default' collection
            .doc('default') // Use the 'default' document
            .get();

        if (defaultSnapshot.exists) {
          final defaultData = defaultSnapshot.data() as Map<String, dynamic>;
          setState(() {
            _videoUrl = defaultData['video_url'] ?? '';
            _statusMessage = _videoUrl.isEmpty
                ? 'Streaming details not found for this channel.'
                : '';
          });
        } else {
          setState(() {
            _statusMessage = 'Streaming details not found for this channel.';
          });
        }
      }
    } on FirebaseException catch (_) {
      setState(() {
        _isError = true;
        _statusMessage =
            'Failed to fetch streaming details. Please try again later.';
      });
    } catch (_) {
      setState(() {
        _isError = true;
        _statusMessage =
            'An unexpected error occurred. Please try again later.';
      });
    } finally {
      if (showLoading && _isInitialLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkConnectivityAndInitializePlayer() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
        _isLoading = false;
        _statusMessage =
            'No internet connection. Please check your connection and try again.';
      });
    } else {
      setState(() {
        _isConnected = true;
      });
      await _fetchStreamingDetails();
      if (_videoUrl.isNotEmpty) {
        _initializePlayer(_videoUrl);
      }
    }
  }

  Future<void> _initializePlayer(String videoUrl) async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });
    try {
      _videoPlayerController = VideoPlayerController.network(
        videoUrl,
      );

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: true,
        fullScreenByDefault: false,
        allowFullScreen: true,
        allowMuting: true,
        autoPlay: true,
        isLive: true,
        cupertinoProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightBlue,
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.lightBlue,
        ),
        hideControlsTimer: const Duration(seconds: 3),
        showControlsOnInitialize: true,
        showOptions: true,
        controlsSafeAreaMinimum: const EdgeInsets.all(0),
        aspectRatio: 16 / 9,
        errorBuilder: (context, error) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            _refresh();
          });
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      );

      setState(() {
        _isLoading = false;
        _isInitialLoading = false;
      });
    } catch (_) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _refresh();
      });
      setState(() {
        _isError = true;
        _statusMessage =
            'An unexpected error occurred. Please try again later.';
        _isLoading = false;
        _isInitialLoading = false;
      });
    }
  }

  Future<void> _checkForUpdates() async {
    // Implement logic to check for updates if needed
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
      _isError = false;
      _isConnected = true;
      _statusMessage = '';
    });
    await _checkConnectivityAndInitializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Stream'),
        backgroundColor: Colors.red,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Center(
          child: _isLoading && _isInitialLoading
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Streaming is being loaded'),
                  ],
                )
              : _isConnected
                  ? _isError
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _statusMessage.isNotEmpty
                                  ? _statusMessage
                                  : 'An error occurred. Please try again.',
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              onPressed: _refresh,
                              child: const Text('Retry'),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            if (_chewieController != null &&
                                _videoPlayerController.value.isInitialized)
                              Chewie(controller: _chewieController!),
                            if (_videoPlayerController.value.isBuffering ||
                                (_isLoading && !_isInitialLoading))
                              const Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                          ],
                        )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.signal_wifi_off,
                            size: 100, color: Colors.red),
                        const SizedBox(height: 20),
                        Text(
                          _statusMessage.isNotEmpty
                              ? _statusMessage
                              : 'No internet connection. Please check your connection and try again.',
                          textAlign: TextAlign.center,
                        ),
                        ElevatedButton(
                          onPressed: _refresh,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
