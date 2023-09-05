import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:upfin/datas/my_data.dart';
import '../utils/common_utils.dart';

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
      loginPlatform = LoginPlatform.kakao;
      callback(true);
    } catch (e) {
      CommonUtils.log("e", "kakao init error : ${e.toString()}");
      callback(false);
    }
  }

  static void _setUserInfo(User user) async {
    MyData.name = user.kakaoAccount!.name!;
    MyData.email = user.kakaoAccount!.email!;
    List<String> phoneDataTemp = user.kakaoAccount!.phoneNumber!.split("-");
    MyData.phoneNumber = "0${phoneDataTemp[0].split(" ")[1]}${phoneDataTemp[1]}${phoneDataTemp[2]}";
    CommonUtils.log("i",
        '이름: ${MyData.name}'
        '\n이메일: ${MyData.email}'
        '\n전화번호: ${MyData.phoneNumber}'
        '\nid: ${user.id}');
  }

  static Future<void> kakaoLogin() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        // 카카오계정으로 로그인
        OAuthToken token;
        if (await isKakaoTalkInstalled()) {
          try {
            token = await UserApi.instance.loginWithKakaoTalk();
            await _getKakaoAgree();
            kakaoToken = token.accessToken;
            CommonUtils.log("i", '카카오계정으로 로그인 성공 ${token.accessToken}');
          } catch (error) {
            if (error is PlatformException && error.code == 'CANCELED') {
              CommonUtils.flutterToast("카카오톡 로그인 중 오류가 발생했습니다.");
              CommonUtils.log("i", '카카오톡으로 로그인 실패 $error');
              return;
            }
            // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
            try {
              token = await UserApi.instance.loginWithKakaoAccount();
              await _getKakaoAgree();
              kakaoToken = token.accessToken;
              CommonUtils.log("i", '카카오계정으로 로그인 성공 ${token.accessToken}');
            } catch (error) {
              CommonUtils.log("i", '카카오계정으로 로그인 실패 $error');
            }
          }
        } else {
          try {
            token = await UserApi.instance.loginWithKakaoAccount();
            await _getKakaoAgree();
            kakaoToken = token.accessToken;
            CommonUtils.log("i", '카카오계정으로 로그인 성공 ${token.accessToken}');
          } catch (error) {
            CommonUtils.log("i", '카카오계정으로 로그인 실패 $error');
          }
        }
      } catch (error) {
        CommonUtils.log("e",'로그인 실패 $error');
      }
    } else {
      CommonUtils.log("i",'발급된 토큰 없음');
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
        _setUserInfo(user);
      } catch (error) {
        CommonUtils.log("e", '사용자 정보 요청 실패 $error');
        CommonUtils.flutterToast("카카오톡 로그인 중 오류가 발생했습니다.");
      }
    } else {
      CommonUtils.flutterToast("카카오톡 설치 후 진행 해 주세요.");
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