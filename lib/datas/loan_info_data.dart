class LoanInfoData {
  String accidentUid;
  String loanUid;
  int offerId;
  int currentStatus;
  int loanTypeId;
  String createdDate;
  String updatedDate;
  String amount;

  LoanInfoData(this.accidentUid, this.loanUid, this.offerId, this.currentStatus, this.loanTypeId, this.createdDate, this.updatedDate, this.amount);
  String printLoanData(){
    return "accidentUid: $accidentUid\nloanUid: $loanUid\nofferId: $offerId"
        "\ncurrentStatus: $currentStatus\nloanTypeId: $loanTypeId\ncreatedDate: $createdDate"
        "\nupdatedDate: $updatedDate\namount: $amount";
  }
}