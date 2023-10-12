import '../datas/loan_info_data.dart';
import '../utils/common_utils.dart';
import 'package:get/get.dart';

class GetController extends GetxController {
  static GetController get to => Get.find();
  RxInt loadingPercent = 0.obs;
  RxBool isWait = false.obs;
  RxBool isConfirmed = false.obs;
  RxString preLoanPrice = "만원".obs;
  RxString wantLoanPrice = "만원".obs;
  RxBool isMainAccidentDataChanged = false.obs;
  RxBool isMainLoanDataChanged = false.obs;
  RxList<LoanInfoData> loanInfoHistDataList = <LoanInfoData>[].obs;
  RxInt firstVisibleItem1 = 0.obs;
  RxInt lastVisibleItem1 = 0.obs;
  RxInt firstVisibleItem2 = 0.obs;
  RxInt lastVisibleItem2 = 0.obs;

  RxInt firstVisibleItem1_2 = 0.obs;
  RxInt lastVisibleItem1_2 = 0.obs;
  RxInt firstVisibleItem2_2= 0.obs;
  RxInt lastVisibleItem2_2 = 0.obs;
  RxInt firstVisibleItem2_3= 0.obs;
  RxInt lastVisibleItem2_3 = 0.obs;

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
    wantLoanPrice = "만원".obs;
  }


  void updatePreLoanPrice(String newValue) {
    preLoanPrice.value = newValue;
  }
  void resetPreLoanPrice() {
    preLoanPrice = "만원".obs;
  }

  void updateLoanHistInfoList(List<LoanInfoData> newList) {
    loanInfoHistDataList.clear();
    loanInfoHistDataList.assignAll(newList);
    CommonUtils.log("i", "loanInfoDataList length : ${loanInfoHistDataList.length}");
  }
  void resetLoanHistInfoList() {
    List<LoanInfoData> emptyList = [];
    loanInfoHistDataList.clear();
    loanInfoHistDataList.assignAll(emptyList);
    CommonUtils.log("i", "loanInfoDataList length : ${loanInfoHistDataList.length}");
  }

  void updateMainAccidentDataChangedFlag() {
    isMainAccidentDataChanged.value = false;
    isMainAccidentDataChanged.value = true;
  }
  void resetMainAccidentDataChangedFlag() {
    isMainAccidentDataChanged = false.obs;
  }

  void updateMainLoanDataChangedFlag() {
    isMainLoanDataChanged.value = false;
    isMainLoanDataChanged.value = true;
  }
  void resetMainLoanDataChangedFlag() {
    isMainLoanDataChanged = false.obs;
  }

  void updateFirstIndex1(int newValue) {
    firstVisibleItem1.value = newValue;
  }
  void resetFirstIndex1() {
    firstVisibleItem1 = 0.obs;
  }
  void updateLastIndex1(int newValue) {
    lastVisibleItem1.value = newValue;
  }
  void resetLastIndex1() {
    lastVisibleItem1 = 0.obs;
  }

  void updateFirstIndex2(int newValue) {
    firstVisibleItem2.value = newValue;
  }
  void resetFirstIndex2() {
    firstVisibleItem2 = 0.obs;
  }
  void updateLastIndex2(int newValue) {
    lastVisibleItem2.value = newValue;
  }
  void resetLastIndex2() {
    lastVisibleItem2 = 0.obs;
  }

  void updateFirstIndex1_2(int newValue) {
    firstVisibleItem1_2.value = newValue;
  }
  void resetFirstIndex1_2() {
    firstVisibleItem1_2 = 0.obs;
  }
  void updateLastIndex1_2(int newValue) {
    lastVisibleItem1_2.value = newValue;
  }
  void resetLastIndex1_2() {
    lastVisibleItem1_2 = 0.obs;
  }

  void updateFirstIndex2_2(int newValue) {
    firstVisibleItem2_2.value = newValue;
  }
  void resetFirstIndex2_2() {
    firstVisibleItem2_2 = 0.obs;
  }
  void updateLastIndex2_2(int newValue) {
    lastVisibleItem2_2.value = newValue;
  }
  void resetLastIndex2_2() {
    lastVisibleItem2_2 = 0.obs;
  }

  void updateFirstIndex2_3(int newValue) {
    firstVisibleItem2_3.value = newValue;
  }
  void resetFirstIndex2_3() {
    firstVisibleItem2_3 = 0.obs;
  }
  void updateLastIndex2_3(int newValue) {
    lastVisibleItem2_3.value = newValue;
  }
  void resetLastIndex2_3() {
    lastVisibleItem2_3 = 0.obs;
  }
}