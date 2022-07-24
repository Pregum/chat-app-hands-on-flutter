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
    apiKey: 'AIzaSyDMpk8yFMQMThnrTe_4Z41Ou57zGw0DFak',
    appId: '1:833001575431:web:2b96ead73fa9a2cd11c6a2',
    messagingSenderId: '833001575431',
    projectId: 'chat-app-hands-on',
    authDomain: 'chat-app-hands-on.firebaseapp.com',
    storageBucket: 'chat-app-hands-on.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCDE_MtCE-T4Q1yTvJHUqil3JHawsmrT9k',
    appId: '1:833001575431:android:11726402175bbd0c11c6a2',
    messagingSenderId: '833001575431',
    projectId: 'chat-app-hands-on',
    storageBucket: 'chat-app-hands-on.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCpGxLE95KhUj8fStq0ED_l5mUNUZmnQZ0',
    appId: '1:833001575431:ios:0c8b03a407ab084b11c6a2',
    messagingSenderId: '833001575431',
    projectId: 'chat-app-hands-on',
    storageBucket: 'chat-app-hands-on.appspot.com',
    iosClientId: '833001575431-dsa0dbh7u87qp9na27b0rv1fph8duum0.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );
}
