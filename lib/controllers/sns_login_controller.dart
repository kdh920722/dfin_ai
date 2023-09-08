import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:upfin/datas/my_data.dart';
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

  static const String kakaoKey = "077c95950e4c99aefd181d2cd069524a";
  static String kakaoToken = "";
  static String kakaoId = "";

  static Future<void> initKakao(Function(bool) callback) async {
    try {
      KakaoSdk.init(nativeAppKey: kakaoKey);
      var key = await KakaoSdk.origin;
      CommonUtils.log("I", "kakao init hash key : $key");
      loginPlatform = LoginPlatform.kakao;
      callback(true);
    } catch (e) {
      CommonUtils.log("e", "kakao init error : ${e.toString()}");
      callback(false);
    }
  }

  static Widget getKakaoLoginButton(BuildContext context, double size, Function(bool? isSuccessToLogin) callback){
    return UiUtils.getIconButton(Icons.add_box, size, ColorStyles.upFinKakaoYellow, () async {
      if(Config.isControllerLoadFinished){
        UiUtils.showLoadingPop(context);
        await SnsLoginController._kakaoLogin((bool isSuccess) async {
          UiUtils.closeLoadingPop(context);
          if(isSuccess){
            MyData.isSnsLogin = true;
            if(await _isMemberFromSns()){
              callback(true);
            }else{
              CommonUtils.flutterToast("회원가입이 필요합니다.");
              callback(false);
            }
          }else{
            MyData.isSnsLogin = false;
            CommonUtils.flutterToast("${SnsLoginController.loginPlatform.value}로그인에 실패했습니다.");
            callback(false);
          }
        });
      }else{
        CommonUtils.flutterToast("데이터 로딩 실패\n다시 실행 해 주세요.");
        callback(null);
      }
    });
  }

  static Widget getAppleLoginButton(BuildContext context, double size, Function(bool? isSuccessToLogin) callback){
    return UiUtils.getIconButton(Icons.add_box, size, ColorStyles.upFinBlack, () async {
      if(Config.isControllerLoadFinished){

      }else{
        CommonUtils.flutterToast("데이터 로딩 실패\n다시 실행 해 주세요.");
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
    if (await isKakaoTalkInstalled()) {
      try {
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
          CommonUtils.log("i", '사용자에게 추가 동의 받아야 하는 항목 ${token.scopes}');
          user = await UserApi.instance.me();
        }

        kakaoId = user.id.toString();
        _setUserInfoFromKakao(user);
      } catch (error) {
        CommonUtils.log("e", '카카오 사용자 정보 요청 실패 $error');
        CommonUtils.flutterToast("카카오 로그인 실패\n다시 실행 해 주세요.");
      }
    } else {
      CommonUtils.flutterToast("카카오톡 설치 후 진행 해 주세요.");
    }
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
      }else{

      }

      Map<String, String> inputJson = {
        "email": MyData.emailFromSns,
        "token": token,
        "user_id": id,
        "provider": SnsLoginController.loginPlatform.value
      };

      CommonUtils.log("i", "social login :\n$inputJson");
      await LogfinController.callLogfinApi(LogfinApis.socialLogin, inputJson, (isSuccess, outputJson) {
        isMember = isSuccess;
      });
      CommonUtils.log("i", "social login 2");
      return isMember;
    }catch(error){
      CommonUtils.log("e", "$error");
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