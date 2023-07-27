import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseController{
  static final FireBaseController _instance = FireBaseController._internal();
  factory FireBaseController() => _instance;
  FireBaseController._internal();

  static Future<void> initializeFirebase() async {
    try {
      var app = await Firebase.initializeApp(
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

      final userCredential = await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          break;
        default:
      }
    }
  }

  static Future<String> getGPTApiKey() async{
    String resultKey = "";
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('ROAMIFY/API_KEYS/gpt').get();
      if (snapshot.exists) {
        return resultKey = snapshot.value.toString();
      } else {
        return resultKey = "error";
      }
    }catch(ex){
      return resultKey = ex.toString();
    }
  }
}