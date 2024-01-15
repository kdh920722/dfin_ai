class AccidentInfoData {
  static const int notNeedToCheckAccount1 = 11; // 11: 환급계좌 체크 필요없고, 계좌정보 있고, 상세 계좌정보 문제 있음.
  static const int notNeedToCheckAccount2 = 12; // 12: 환급계좌 체크 필요없고, 계좌정보 있고, 상세 계좌정보 문제 없음.
  static const int needToCheckAccount1 = 1; // 1: 환급계좌 체크 필요하고, 계좌정보 있고, 상세 계좌정보 문제 있음.
  static const int needToCheckAccount2 = 2; // 2: 환급계좌 체크 필요하고, 계좌정보 있고, 상세 계좌정보 문제 없음.
  static int getAccidentAccountValidType(bool isNeedToCheckAccount, Map<String, dynamic> accountData){
    int validType = 0;
    if(isNeedToCheckAccount){
      validType += 1;

      bool isSuccessToGetDetailInfo = true;
      if(accountData.containsKey("resRepaymentList")){
        List<dynamic> tempList = accountData["resRepaymentList"];
        if(tempList.isEmpty){
          isSuccessToGetDetailInfo = false;
        }else{
          if(accountData["resRepaymentList"][0]["resAmount"] == ""
              || accountData["resRepaymentList"][0]["resRoundNo"] == ""
              || accountData["resRepaymentList"][0]["resUnpaidAmt"] == ""
              || accountData["resRepaymentList"][0]["resRoundNo2"] == ""
              || accountData["resRepaymentList"][0]["resRoundNo1"] == ""
              || accountData["resRepaymentList"][0]["resTotalAmt"] == ""
              || accountData["resRepaymentList"][0]["resRepaymentCycle"] == ""){
            isSuccessToGetDetailInfo = false;
          }
        }
      }else{
        isSuccessToGetDetailInfo = false;
      }

      if(isSuccessToGetDetailInfo){
        validType += 1;
      }
    }else{
      validType += 11;

      bool isSuccessToGetDetailInfo = true;
      if(accountData.containsKey("resRepaymentList")){
        List<dynamic> tempList = accountData["resRepaymentList"];
        if(tempList.isEmpty){
          isSuccessToGetDetailInfo = false;
        }else{
          if(accountData["resRepaymentList"][0]["resAmount"] == ""
              || accountData["resRepaymentList"][0]["resRoundNo"] == ""
              || accountData["resRepaymentList"][0]["resUnpaidAmt"] == ""
              || accountData["resRepaymentList"][0]["resRoundNo2"] == ""
              || accountData["resRepaymentList"][0]["resRoundNo1"] == ""
              || accountData["resRepaymentList"][0]["resTotalAmt"] == ""
              || accountData["resRepaymentList"][0]["resRepaymentCycle"] == ""){
            isSuccessToGetDetailInfo = false;
          }
        }
      }else{
        isSuccessToGetDetailInfo = false;
      }

      if(isSuccessToGetDetailInfo){
        validType += 1;
      }
    }

    return validType;
  }

  String id;
  String accidentUid;
  String accidentCaseNumberYear;
  String accidentCaseNumberType;
  String accidentCaseNumberNumber;
  String accidentCourtInfo;
  String accidentBankInfo;
  String accidentBankAccount;
  String accidentLendCount;
  String accidentLendAmount;
  String accidentWishAmount;
  String date;
  int accidentAccountValidType;
  Map<String, dynamic> resData;

  AccidentInfoData(this.id, this.accidentUid, this.accidentCaseNumberYear, this.accidentCaseNumberType, this.accidentCaseNumberNumber,
      this.accidentCourtInfo, this.accidentBankInfo, this.accidentBankAccount,
      this.accidentLendCount, this.accidentLendAmount, this.accidentWishAmount, this.date, this.accidentAccountValidType, this.resData);


}