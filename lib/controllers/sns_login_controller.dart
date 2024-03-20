import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:dfin/controllers/sharedpreference_controller.dart';
import 'package:dfin/datas/my_data.dart';
import '../configs/app_config.dart';
import '../styles/ColorStyles.dart';
import '../utils/common_utils.dart';
import '../utils/ui_utils.dart';
import 'logfin_controller.dart';

enum LoginPlatform {
  kakao, apple, none
}

extension LoginPlatformExtension on LoginPlatform {
  String get value {
    switch (this) {
      case LoginPlatform.kakao:
        return 'kakao';
      case LoginPlatform.apple:
        return 'apple';
      case LoginPlatform.none:
        return '';
    }
  }
}

class SnsLoginController{
  static LoginPlatform loginPlatform = LoginPlatform.none;

  static const String kakaoKey = "8b274aad5e2a4f3b8a5a1530750bc1ad";
  static String kakaoToken = "";
  static String kakaoId = "";
  static String appleUrl = "";
  static String appleServiceId = "";
  static String appleToken = "";
  static String appleId = "";

  static Future<void> initKakao(Function(bool) callback) async {
    try {
      KakaoSdk.init(nativeAppKey: kakaoKey);
      var key = await KakaoSdk.origin;
      CommonUtils.log("I", "kakao init hash key : $key");
      callback(true);
    } catch (e) {
      CommonUtils.log("e", "kakao init error : ${e.toString()}");
      callback(false);
    }
  }

  static Future<void> initApple(Function(bool) callback) async {
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('DFIN/API/apple').get();
      if (snapshot.exists) {
        for(var each in snapshot.children){
          switch(each.key){
            case "redirect_url" : appleUrl = each.value.toString();
            case "service_id" : appleServiceId = each.value.toString();
          }
        }

        callback(true);
      } else {
        callback(false);
      }
    } catch (e) {
      CommonUtils.log("e", "apple init error : ${e.toString()}");
      callback(false);
    }
  }

  static Widget getKakaoLoginButton(BuildContext context, double size, Function(bool? isSuccessToLogin) callback){
    return UiUtils.getCircleImageButton(Image.asset('assets/images/logo_kakao_circle.png', fit: BoxFit.fill), size, ColorStyles.dFinBlack, () async {
      if(Config.isControllerLoadFinished){
        if(Config.isAndroid) UiUtils.showLoadingPop(context);
        loginPlatform = LoginPlatform.kakao;
        await SnsLoginController._kakaoLogin((bool isSuccess) async {
          if(Config.isAndroid) UiUtils.closeLoadingPop(context);
          if(isSuccess){
            MyData.isSnsLogin = true;
            if(await _isMemberFromSns()){
              callback(true);
            }else{
              CommonUtils.flutterToast("회원가입이 필요해요. ");
              callback(false);
            }
          }else{
            MyData.isSnsLogin = false;
            CommonUtils.flutterToast("${SnsLoginController.loginPlatform.value}로그인에 실패했어요.");
            loginPlatform = LoginPlatform.none;
            callback(false);
          }
        });
      }else{
        CommonUtils.flutterToast("데이터 로딩 실패\n다시 실행 해 주세요.");
        loginPlatform = LoginPlatform.none;
        callback(null);
      }
    });
  }

  static Widget getAppleLoginButton(BuildContext context, double size, Function(bool? isSuccessToLogin) callback){
    return UiUtils.getCircleImageButton(Image.asset('assets/images/logo_apple_circle.png', fit: BoxFit.fill), size, ColorStyles.dFinWhite, () async {
      if(Config.isControllerLoadFinished){
        try{
          UiUtils.showLoadingPop(context);
          loginPlatform = LoginPlatform.apple;
          final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            webAuthenticationOptions: WebAuthenticationOptions(
              clientId: appleServiceId,
              redirectUri: Uri.parse(appleUrl),
            ),
          );
          MyData.isSnsLogin = true;
          appleToken = credential.identityToken!;
          List<String> jwt = appleToken.split('.');
          String payload = jwt[1];
          payload = base64.normalize(payload);
          final List<int> jsonData = base64.decode(payload);
          final userInfo = jsonDecode(utf8.decode(jsonData));
          appleId = userInfo['sub'];

          _setUserInfoFromApple(credential);
          if(context.mounted){
            UiUtils.closeLoadingPop(context);
            if(await _isMemberFromSns()){
              callback(true);
            }else{
              CommonUtils.flutterToast("회원가입이 필요해요.");
              callback(false);
            }
          }
        }catch(error){
          CommonUtils.log("e", error.toString());
          if(context.mounted) UiUtils.closeLoadingPop(context);
          MyData.isSnsLogin = false;
          CommonUtils.flutterToast("${SnsLoginController.loginPlatform.value}로그인에 실패했어요.");
          loginPlatform = LoginPlatform.none;
          callback(false);
        }
      }else{
        CommonUtils.flutterToast("데이터 로딩 실패\n다시 실행 해 주세요.");
        MyData.isSnsLogin = false;
        loginPlatform = LoginPlatform.none;
        callback(null);
      }
    });
  }

  static Future<void> _kakaoLogin(Function(bool) callback) async {
    try {
      // 카카오계정으로 로그인
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
          await _getKakaoAgree();
          kakaoToken = token.accessToken;
          callback(true);
        } catch (error) {
          if (error is PlatformException && error.code == 'CANCELED') {
            CommonUtils.flutterToast("카카오톡 로그인 실패\n다시 실행 해 주세요.");
            CommonUtils.log("e", '카카오톡으로 로그인 실패 $error');
            callback(false);
            return;
          }
          // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
          try {
            token = await UserApi.instance.loginWithKakaoAccount();
            await _getKakaoAgree();
            kakaoToken = token.accessToken;
            callback(true);
          } catch (error) {
            CommonUtils.log("e", '카카오계정으로 로그인 실패 $error');
            callback(false);
          }
        }
      } else {
        try {
          token = await UserApi.instance.loginWithKakaoAccount();
          await _getKakaoAgree();
          kakaoToken = token.accessToken;
          callback(true);
        } catch (error) {
          CommonUtils.log("e", '카카오계정으로 로그인 실패 $error');
          callback(false);
        }
      }
    } catch (error) {
      CommonUtils.log("e",'카카오 로그인 실패 $error');
      callback(false);
    }
  }

  static Future<void> _getKakaoAgree() async {
    User user = await UserApi.instance.me();
    List<String> scopes = [];

    if (user.kakaoAccount?.emailNeedsAgreement == true) {
      scopes.add('account_email');
    }

    if (user.kakaoAccount?.nameNeedsAgreement == true) {
      scopes.add('name');
    }

    if (user.kakaoAccount?.phoneNumberNeedsAgreement == true) {
      scopes.add("phone_number");
    }

    if (scopes.isNotEmpty) {
      OAuthToken token = await UserApi.instance.loginWithNewScopes(scopes);
      CommonUtils.log("", '사용자에게 추가 동의 받아야 하는 항목 ${token.scopes}');
      user = await UserApi.instance.me();
    }

    kakaoId = user.id.toString();
    _setUserInfoFromKakao(user);
  }

  static void _setUserInfoFromApple(AuthorizationCredentialAppleID user) async {
    String fName = "";
    if(user.familyName != null){
      fName = user.familyName!;
    }
    String gName = "";
    if(user.givenName != null){
      gName = user.givenName!;
    }
    String email = "";
    if(user.email != null){
      email = user.email!;
    }else{
      List<String> jwt = appleToken.split('.');
      String payload = jwt[1];
      payload = base64.normalize(payload);

      final List<int> jsonData = base64.decode(payload);
      CommonUtils.log("i",utf8.decode(jsonData).toString());
      final userInfo = jsonDecode(utf8.decode(jsonData));
      email = userInfo['email'];
    }

    MyData.nameFromSns = fName + gName;
    MyData.emailFromSns = email;
    MyData.phoneNumberFromSns = "";
  }


  static void _setUserInfoFromKakao(User user) async {
    MyData.nameFromSns = user.kakaoAccount!.name!;
    MyData.emailFromSns = user.kakaoAccount!.email!;
    List<String> phoneDataTemp = user.kakaoAccount!.phoneNumber!.split("-");
    MyData.phoneNumberFromSns = "0${phoneDataTemp[0].split(" ")[1]}${phoneDataTemp[1]}${phoneDataTemp[2]}";
  }

  static Future<bool> _isMemberFromSns() async {
    try{
      bool isMember = false;
      String token = "";
      String id = "";
      if(SnsLoginController.loginPlatform == LoginPlatform.kakao){
        token = SnsLoginController.kakaoToken;
        id = SnsLoginController.kakaoId;
      }else if(SnsLoginController.loginPlatform == LoginPlatform.apple){
        token = appleToken;
        id = appleId;
      }

      Map<String, String> inputJson = {
        "email": MyData.emailFromSns,
        "token": token,
        "user_id": id,
        "provider": SnsLoginController.loginPlatform.value
      };

      await LogfinController.callLogfinApi(LogfinApis.socialLogin, inputJson, (isSuccess, outputJson) {
        SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceSnsToken, token);
        SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceSnsId, id);
        SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceSnsType, SnsLoginController.loginPlatform.value);
        SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceIsSnsLogin, "Y");
        if(isSuccess){
          SharedPreferenceController.saveSharedPreference(SharedPreferenceController.sharedPreferenceIdKey, MyData.emailFromSns);
        }
        isMember = isSuccess;
      });
      return isMember;
    }catch(error){
      CommonUtils.log("error", "$error");
      return false;
    }
  }

  static void logOut() async {
    switch (loginPlatform) {
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        break;
      case LoginPlatform.apple:
        break;
      case LoginPlatform.none:
        break;
    }

    loginPlatform = LoginPlatform.none;
  }
}