import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your EcoSort app.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA_placeholder_for_ecosort_web',
    appId: '1:100000000000:web:ecosortweb123456',
    messagingSenderId: '100000000000',
    projectId: 'ecosort-household-waste',
    authDomain: 'ecosort-household-waste.firebaseapp.com',
    storageBucket: 'ecosort-household-waste.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_placeholder_for_ecosort_android',
    appId: '1:100000000000:android:ecosortapp123456',
    messagingSenderId: '100000000000',
    projectId: 'ecosort-household-waste',
    storageBucket: 'ecosort-household-waste.appspot.com',
  );
}
