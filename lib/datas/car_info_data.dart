import '../utils/common_utils.dart';

class CarInfoData {
  String id;
  String carUid;
  String carNum;
  String carOwnerName;
  String carPrice;
  String carLendCount;
  String carLendAmount;
  String carWishAmount;
  String date;
  String carModel;
  String carModelDetail;
  String carImage;
  List<dynamic> regBData;
  Map<String, dynamic> resData;

  static Map<String,dynamic> getConvertedRegBMap(Map<String,dynamic> dataMap){
    Map<String,dynamic> resultRegBMap = {};
    resultRegBMap["resLedgerBNo"] = dataMap["resLedgerBNo"];
    dataMap["resUserNm"] = dataMap["resUserNm"].toString().replaceAll("주식회사", "(주)").replaceAll("+", "");
    resultRegBMap["resUserNm"] = dataMap["resUserNm"];
    resultRegBMap["resBondPrice"] = dataMap["resBondPrice"].toString();
    resultRegBMap["commStartDate"] = dataMap["commStartDate"].toString();
    resultRegBMap["resBondPriceTxt"] = CommonUtils.getPriceFormattedStringForFullPrice(double.parse(dataMap["resBondPrice"].toString()));
    resultRegBMap["commStartDateTxt1"] = "${dataMap["commStartDate"].toString().substring(0,4)}년 ${dataMap["commStartDate"].toString().substring(4,6)}월 ${dataMap["commStartDate"].toString().substring(6)}일";
    resultRegBMap["commStartDateTxt2"] = "${dataMap["commStartDate"].toString().substring(0,4)}.${dataMap["commStartDate"].toString().substring(4,6)}.${dataMap["commStartDate"].toString().substring(6)}";

    return resultRegBMap;
  }

  CarInfoData(this.id, this.carUid, this.carNum, this.carOwnerName, this.carPrice,
      this.carLendCount, this.carLendAmount, this.carWishAmount, this.date, this.carModel, this.carModelDetail, this.carImage, this.regBData, this.resData);
}