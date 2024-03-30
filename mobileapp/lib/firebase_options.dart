// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAql5cSTcRKWRTpWy2kF6OqkWsdGVVG_1A',
    appId: '1:217926907745:android:426149dc3b8aee5d6ef720',
    messagingSenderId: '217926907745',
    projectId: 'pusl2022-uptime',
    databaseURL: 'https://pusl2022-uptime-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'pusl2022-uptime.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpRLwrcbOqEFZE954gPvzzbHRzY8_CMTg',
    appId: '1:217926907745:ios:e34cb379b35759336ef720',
    messagingSenderId: '217926907745',
    projectId: 'pusl2022-uptime',
    databaseURL: 'https://pusl2022-uptime-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'pusl2022-uptime.appspot.com',
    iosBundleId: 'UpTime.com.mobileapp',
  );
}
