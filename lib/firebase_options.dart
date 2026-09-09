// File generated manually based on Firebase Console web app configuration
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAOuuaYUewrUOiXW_h6iXuPjQD5GCAJtPs',
    appId: '1:1016241696831:web:e782767a6ca1f79556088a',
    messagingSenderId: '1016241696831',
    projectId: 'recipe-app-aa3c4',
    authDomain: 'recipe-app-aa3c4.firebaseapp.com',
    storageBucket: 'recipe-app-aa3c4.firebasestorage.app',
    measurementId: 'G-3Z1Q929371',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABebP-hKJ0ngLcqerE99Y1Ip4d_p4xR3I',
    appId: '1:1016241696831:android:d56de35baaa40e8d56088a',
    messagingSenderId: '1016241696831',
    projectId: 'recipe-app-aa3c4',
    storageBucket: 'recipe-app-aa3c4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAOuuaYUewrUOiXW_h6iXuPjQD5GCAJtPs',
    appId: '1:1016241696831:web:e782767a6ca1f79556088a',
    messagingSenderId: '1016241696831',
    projectId: 'recipe-app-aa3c4',
    storageBucket: 'recipe-app-aa3c4.firebasestorage.app',
  );
}
