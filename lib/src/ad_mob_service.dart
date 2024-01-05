import 'dart:io';

class AdMobService {
  static String? get bannerAdUnitId {
    bool test = true;
    if (Platform.isAndroid) {
      if (test) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-9518180100017667/1121420069';
      }
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String? get rewardedAdUnitId {
    bool test = true;
    if (Platform.isAndroid) {
      if (test) {
        return 'ca-app-pub-3940256099942544/5224354917';
      } else {
        return 'ca-app-pub-9518180100017667/1990830363';
      }
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}
