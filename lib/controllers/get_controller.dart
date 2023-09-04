import '../utils/common_utils.dart';
import 'package:get/get.dart';

class GetController extends GetxController {
  static GetController get to => Get.find();
  RxDouble counter = 0.0.obs;
  RxBool isWait = false.obs;

  @override
  void onInit() {
    CommonUtils.log("i", 'get 컨트롤러가 생성됩니다.');
    once(counter, (_) {
      print('once : $_이 처음으로 변경되었습니다.');
    });
    ever(counter, (_) {
      print('ever : $_이 변경되었습니다.');
    });
    debounce(
      counter, (_) {
      print('debounce : $_가 마지막으로 변경된 이후, 1초간 변경이 없습니다.');
    },
      time: const Duration(seconds: 1),
    );
    interval(
      counter, (_) {
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

  void updateCounter(double newValue) {
    counter.value = newValue;
  }

  void updateWait(bool newValue) {
    isWait.value = newValue;
  }
}