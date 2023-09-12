class PrInfoData {
  String productOfferId;
  String productOfferRid;
  String productCompanyName;
  String productCompanyCode;
  String productName;
  String productCode;
  String productLoanRates;
  String productLoanLimit;
  bool isPossible;
  List<dynamic> failReason;

  PrInfoData(this.productOfferId, this.productOfferRid, this.productCompanyName, this.productCompanyCode, this.productName,
      this.productCode, this.productLoanRates, this.productLoanLimit, this.isPossible, this.failReason);
}