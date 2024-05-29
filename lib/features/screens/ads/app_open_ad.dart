import 'dart:math';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {
  static const String adUnitId = 'ca-app-pub-8707896599237541/3183727532';
  static AppOpenAd? _appOpenAd;
  static bool _isShowingAd = false;
  static bool _adShownOnce = false; // Track if the ad has been shown at least once
  static bool _adLoaded = false; // To track if an ad is loaded

  // Random generator for showing ad after random intervals
  static final Random _random = Random();

  static void loadAppOpenAd() {
    if (_isShowingAd || _appOpenAd != null) return;

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _adLoaded = true;
          // Check if the ad has been shown once, if not, show it
          if (!_adShownOnce) {
            _showAppOpenAd();
          }
        },
        onAdFailedToLoad: (error) {
          print('Failed to load an app open ad: ${error.message}');
          _appOpenAd = null;
          _adLoaded = false;
        },
      ),
    );
  }

  static void _showAppOpenAd() {
    if (_appOpenAd != null && !_isShowingAd) {
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _isShowingAd = true;
        },
        onAdDismissedFullScreenContent: (ad) {
          _isShowingAd = false;
          ad.dispose();
          _appOpenAd = null;
          // Set the flag to true after the ad is shown once
          _adShownOnce = true;
          _adLoaded = false; // Reset the flag when the ad is dismissed
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Failed to show app open ad: $error');
          _isShowingAd = false;
          ad.dispose();
          _appOpenAd = null;
          _adLoaded = false; // Reset the flag if ad fails to show
        },
      );
      _appOpenAd!.show();
    }
  }

  static void showAdIfAvailable() {
    if (_adLoaded && !_isShowingAd) {
      // Generate a random number to decide whether to show the ad
      if (_random.nextDouble() < 0.5) {
        // Adjust the probability as needed
        _showAppOpenAd();
      }
    }
  }
}
