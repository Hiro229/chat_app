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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDAqU3J1nUUcq1M6Im3E7obKDSbfJGF3KU',
    appId: '1:1080805637245:web:fe0b5aa07971f981fe4514',
    messagingSenderId: '1080805637245',
    projectId: 'chatapp-b8e33',
    authDomain: 'chatapp-b8e33.firebaseapp.com',
    storageBucket: 'chatapp-b8e33.appspot.com',
    measurementId: 'G-BZ7V0E094S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC23Oi7b4rgY9ytZ5LsHScy9XdgpDoEBj8',
    appId: '1:1080805637245:android:bf99bf9ff96e770dfe4514',
    messagingSenderId: '1080805637245',
    projectId: 'chatapp-b8e33',
    storageBucket: 'chatapp-b8e33.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC22aNbqhtkWnN7R3JaWgabAbmAF-Fj1OQ',
    appId: '1:1080805637245:ios:15fed3a715e1cb07fe4514',
    messagingSenderId: '1080805637245',
    projectId: 'chatapp-b8e33',
    storageBucket: 'chatapp-b8e33.appspot.com',
    androidClientId: '1080805637245-vpddj2eg3212ldjhnr3bqgkc7m3lq21p.apps.googleusercontent.com',
    iosClientId: '1080805637245-4vhb22ql23rostu78hfdc4brj60qsded.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC22aNbqhtkWnN7R3JaWgabAbmAF-Fj1OQ',
    appId: '1:1080805637245:ios:b3c5fa31ef23adf3fe4514',
    messagingSenderId: '1080805637245',
    projectId: 'chatapp-b8e33',
    storageBucket: 'chatapp-b8e33.appspot.com',
    androidClientId: '1080805637245-vpddj2eg3212ldjhnr3bqgkc7m3lq21p.apps.googleusercontent.com',
    iosClientId: '1080805637245-la84te18h5l8k5jqjq5q8upigli3lr8m.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp.RunnerTests',
  );
}
