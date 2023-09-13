import '../utils/common_utils.dart';
import 'package:get/get.dart';

class GetController extends GetxController {
  static GetController get to => Get.find();
  RxInt loadingPercent = 0.obs;
  RxBool isWait = false.obs;
  RxBool isConfirmed = false.obs;
  RxString preLoanPrice = "만원".obs;
  RxString wantLoanPrice = "만원".obs;

  @override
  void onInit() {
    CommonUtils.log("i", 'get 컨트롤러가 생성됩니다.');
    once(loadingPercent, (_) {
      print('once : $_이 처음으로 변경되었습니다.');
    });
    ever(loadingPercent, (_) {
      print('ever : $_이 변경되었습니다.');
    });
    debounce(
      loadingPercent, (_) {
      print('debounce : $_가 마지막으로 변경된 이후, 1초간 변경이 없습니다.');
    },
      time: const Duration(seconds: 1),
    );
    interval(
      loadingPercent, (_) {
      print('interval $_가 변경되는 중입니다.(1초마다 호출)');
    },
      time: const Duration(seconds: 1),
    );
    super.onInit();
  }

  @override
  void onClose() {
    CommonUtils.log("i", '컨트롤러가 삭제됩니다.');
    super.onClose();
  }

  void updatePercent(int newValue) {
    loadingPercent.value += newValue;
  }
  void resetPercent() {
    loadingPercent = 0.obs;
  }


  void updateWait(bool newValue) {
    isWait.value = newValue;
  }
  void resetIsWait() {
    isWait = false.obs;
  }


  void updateConfirmed(bool newValue) {
    isConfirmed.value = newValue;
  }
  void resetConfirmed() {
    isConfirmed = false.obs;
  }


  void updateWantLoanPrice(String newValue) {
    wantLoanPrice.value = newValue;
  }
  void resetWantLoanPrice() {
    preLoanPrice = "만원".obs;
  }


  void updatePreLoanPrice(String newValue) {
    preLoanPrice.value = newValue;
  }
  void resetPreLoanPrice() {
    preLoanPrice = "만원".obs;
  }
}