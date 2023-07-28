import '../utils/common_utils.dart';
import 'package:get/get.dart';

class GetController extends GetxController {
  static GetController get to => Get.find();
  RxDouble counter = 0.0.obs;

  @override
  void onInit() {
    CommonUtils.log("i", '컨트롤러가 생성됩니다.');
    once(counter, (_) {
      CommonUtils.log("i", 'once : $_이 처음으로 변경되었습니다.');
    });
    ever(counter, (_) {
      print('ever : $_이 변경되었습니다.');
    });
    debounce(
      counter, (_) {
      CommonUtils.log("i", 'debounce : $_가 마지막으로 변경된 이후, 1초간 변경이 없습니다.');
    },
      time: Duration(seconds: 1),
    );
    interval(
      counter, (_) {
      CommonUtils.log("i", 'interval $_가 변경되는 중입니다.(1초마다 호출)');
    },
      time: Duration(seconds: 1),
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
    print("update counter : ${counter.value}");
  }
}