// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDLv-vuA-uZPt2wO5ixIeiCPjLzO_ve3c4',
    appId: '1:73979685450:web:065bd99e80b8c74674d4b3',
    messagingSenderId: '73979685450',
    projectId: 'loja-virtual-c5945',
    authDomain: 'loja-virtual-c5945.firebaseapp.com',
    storageBucket: 'loja-virtual-c5945.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDG2-Ftl4u6XYIaeXR5gQHhfIhwhEB0AS8',
    appId: '1:73979685450:android:9d4995b1842d5f8c74d4b3',
    messagingSenderId: '73979685450',
    projectId: 'loja-virtual-c5945',
    storageBucket: 'loja-virtual-c5945.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD7uJBgOx969ykQNX21-lugvPH5c0nKP6A',
    appId: '1:73979685450:ios:cfa1702385ddc44774d4b3',
    messagingSenderId: '73979685450',
    projectId: 'loja-virtual-c5945',
    storageBucket: 'loja-virtual-c5945.appspot.com',
    iosBundleId: 'com.example.lojaVirtual',
  );
}
