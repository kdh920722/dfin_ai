class PrInfoData {
  String productOfferId;
  String productOfferRid;
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

  PrInfoData(this.productOfferId, this.productOfferRid, this.productCompanyName, this.productCompanyCode, this.productName,
      this.productCode, this.productLoanMinRates, this.productLoanMaxRates, this.productLoanLimit, this.productCompanyLogo, this.isPossible, this.failReason);
}