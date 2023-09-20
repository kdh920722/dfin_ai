class LoanInfoData {
  String accidentUid;
  String loanUid;
  String lenderPrId;
  String submitAmount;
  String submitRate;
  String companyName;
  String productName;
  String contactNo;
  String createdDate;
  String updatedDate;
  String statueId;

  LoanInfoData(this.accidentUid, this.loanUid, this.lenderPrId, this.submitAmount, this.submitRate,
      this.companyName, this.productName,  this.contactNo, this.createdDate, this.updatedDate, this.statueId);
  String printLoanData(){
    return "\naccidentUid: $accidentUid\nloanUid: $loanUid\nlenderPrId: $lenderPrId\nsubmitAmount: $submitAmount"
        "\nsubmitRate: $submitRate\ncompanyName: $companyName\nproductName: $productName\ncompanyCallNum: $contactNo"
        "\ncreatedDate: $createdDate\nupdatedDate: $updatedDate\nstatueId: $statueId";
  }
}