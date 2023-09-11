class PrInfoData {
  String productCompanyName;
  String productCompanyCode;
  String productName;
  String productCode;
  String productLoanRates;
  String productLoanLimit;
  bool isPossible;
  List<dynamic> failReason;

  PrInfoData(this.productCompanyName, this.productCompanyCode, this.productName, this.productCode, this.productLoanRates, this.productLoanLimit, this.isPossible, this.failReason);
}