import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return web;
      case TargetPlatform.iOS:
        return web;
      case TargetPlatform.macOS:
        return web;
      case TargetPlatform.windows:
        return web;
      case TargetPlatform.linux:
        return web;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD0DU4uCSYz3i-Dl-CjgoMOOxxw2IIpoXM',
    appId: '1:625308447518:web:9ba815ef0433907009cf0f',
    messagingSenderId: '625308447518',
    projectId: 'menuhub-edcd7',
    authDomain: 'menuhub-edcd7.firebaseapp.com',
    storageBucket: 'menuhub-edcd7.firebasestorage.app',
    measurementId: 'G-1942Z09JJK',
  );
}