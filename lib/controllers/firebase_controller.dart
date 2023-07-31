import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/common_utils.dart';

class FireBaseController{
  static final FireBaseController _instance = FireBaseController._internal();
  factory FireBaseController() => _instance;
  FireBaseController._internal();
  static FirebaseApp? firebaseApp;
  static UserCredential? userCredential;

  static Future<void> initFirebase(Function(bool) callback) async {
    try {
      firebaseApp = await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyAP0g-SSeuXgSa4crBmrCLWavwrksQSOQk",
              authDomain: "soarkidz-8ac85.firebaseapp.com",
              databaseURL: "https://soarkidz-8ac85-default-rtdb.firebaseio.com",
              projectId: "soarkidz-8ac85",
              storageBucket: "soarkidz-8ac85.appspot.com",
              messagingSenderId: "31796873395",
              appId: "1:31796873395:web:c4a15d7285eb17dd6848c6",
              measurementId: "G-50NECGL8FT"
          )
      );

      userCredential = await FirebaseAuth.instance.signInAnonymously();
      callback(true);
    } on FirebaseAuthException catch (e) {
      CommonUtils.log("e", "firebase init error : ${e.code} : ${e.toString()}");
      callback(false);
    }
  }
}