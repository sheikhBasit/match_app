import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:wakelock/wakelock.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class StreamingPage extends StatefulWidget {
  const StreamingPage({Key? key}) : super(key: key);

  @override
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  String longVideo = "https://sportsleading.online/live/stream_nba1.m3u8";
  Map<String, String> headers = {
    "origin": "https://streambtw.com",
    "referer": "https://streambtw.com/",
    "User-Agent": "Mozilla"
  };
  bool _isLoading = true;
  bool _isError = false;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _checkConnectivityAndInitializePlayer();
  }

  Future<void> _checkConnectivityAndInitializePlayer() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnected = false;
        _isLoading = false;
      });
    } else {
      _initializePlayer(longVideo);
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
        httpHeaders: headers,
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
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    _checkConnectivityAndInitializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Stream'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: _isLoading
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
                          const Text(
                              'No internet..Please check your connection and try again.',
                              textAlign: TextAlign.center),
                          ElevatedButton(
                            onPressed: _refresh,
                            child: const Text('Retry'),
                          ),
                        ],
                      )
                    : Chewie(controller: _chewieController!)
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.signal_wifi_off, size: 100, color: Colors.red),
                      SizedBox(height: 20),
                      Text(
                          'No internet connection. Please check your connection and try again.'),
                    ],
                  ),
      ),
    );
  }
}
