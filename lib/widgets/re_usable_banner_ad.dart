import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ReusableBannerAd extends StatefulWidget {
  @override
  _ReusableBannerAdState createState() => _ReusableBannerAdState();
}

class _ReusableBannerAdState extends State<ReusableBannerAd> {
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    String adUnitId;

    if (Platform.isAndroid) {
      adUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Replace with Android ad unit ID
    } else if (Platform.isIOS) {
      adUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Replace with iOS ad unit ID
    } else {
      adUnitId = ''; // Default empty if platform is not Android or iOS
    }

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isBannerAdReady) {
      return Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    } else {
      return SizedBox.shrink(); // Empty space if ad is not ready
    }
  }
}
