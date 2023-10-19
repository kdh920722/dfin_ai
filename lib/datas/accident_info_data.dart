class AccidentInfoData {
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
  Map<String, dynamic> resData;

  AccidentInfoData(this.id, this.accidentUid, this.accidentCaseNumberYear, this.accidentCaseNumberType, this.accidentCaseNumberNumber,
      this.accidentCourtInfo, this.accidentBankInfo, this.accidentBankAccount,
      this.accidentLendCount, this.accidentLendAmount, this.accidentWishAmount, this.resData);
}