class PrInfoData {
  String accidentUid;
  String productOfferId;
  String productOfferRid;
  String productOfferLenderPrId;
  String productCompanyName;
  String productCompanyCode;
  String productName;
  String productCode;
  String productLoanMinRates;
  String productLoanMaxRates;
  String productLoanLimit;
  String productCompanyLogo;
  bool isPossible;
  List<dynamic> failReason;

  PrInfoData(this.accidentUid, this.productOfferId, this.productOfferRid, this.productOfferLenderPrId, this.productCompanyName, this.productCompanyCode, this.productName,
      this.productCode, this.productLoanMinRates, this.productLoanMaxRates, this.productLoanLimit, this.productCompanyLogo, this.isPossible, this.failReason);
}