class PrInfoData {
  String uid;
  String uidType; // 1 : accident,  3 : car
  String productOfferId;
  String productOfferRid;
  String productOfferLenderPrId;
  String productCompanyName;
  String productCompanyCode;
  String productDocCode;
  String productName;
  String productCode;
  String productLoanMinRates;
  String productLoanMaxRates;
  String productLoanLimit;
  String productCompanyLogo; // company icon or path
  bool isPossible;
  Map<String, dynamic> lenderInfo;
  List<dynamic> failReason;

  PrInfoData(this.uid, this.uidType, this.productOfferId, this.productOfferRid, this.productOfferLenderPrId, this.productCompanyName, this.productCompanyCode, this.productDocCode, this.productName,
      this.productCode, this.productLoanMinRates, this.productLoanMaxRates, this.productLoanLimit, this.productCompanyLogo, this.isPossible, this.lenderInfo, this.failReason);
}