import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterwebchat/configs/app_config.dart';
import '../configs/firebase_options.dart';
import '../utils/common_utils.dart';

class FireBaseController{
  static final FireBaseController _instance = FireBaseController._internal();
  factory FireBaseController() => _instance;
  FireBaseController._internal();
  static FirebaseApp? firebaseApp;
  static UserCredential? userCredential;

  static Future<void> initFirebase(Function(bool) callback) async {
    try {
      firebaseApp = await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      userCredential = await FirebaseAuth.instance.signInAnonymously();
      callback(true);
    } on FirebaseAuthException catch (e) {
      CommonUtils.log("e", "firebase init error : ${e.code} : ${e.toString()}");
      callback(false);
    }
  }
}