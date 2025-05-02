import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAuwqE-r_jnzRqPfDnpJDuu1bzC_udgXZU',
    appId: '1:951071912640:android:fa63a5f9a3caa9f2707325',
    messagingSenderId: '951071912640',
    projectId: 'simple-todo-list-21',
    storageBucket: 'simple-todo-list-21.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4Eg6SHaAan9wLoXNQyeB6Ur6BrGUd3Ls',
    appId: '1:951071912640:ios:61df62234c9158dd707325',
    messagingSenderId: '951071912640',
    projectId: 'simple-todo-list-21',
    storageBucket: 'simple-todo-list-21.firebasestorage.app',
    iosBundleId: 'com.example.simpleTodoFlutter',
  );
}
