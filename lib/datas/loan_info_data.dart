class LoanInfoData {
  String uid;
  String uidType; // 1 : accident,  3 : car
  String loanUid;
  String lenderPrId;
  String submitAmount;
  String submitRate;
  String companyName;
  String companyLogo;
  String productName;
  String contactNo;
  String createdDate;
  String updatedDate;
  String statueId;
  String chatRoomId;
  String chatRoomMsg;

  LoanInfoData(this.uid, this.uidType, this.loanUid, this.lenderPrId, this.submitAmount, this.submitRate,
      this.companyName, this.companyLogo, this.productName,  this.contactNo, this.createdDate,
      this.updatedDate, this.statueId, this.chatRoomId, this.chatRoomMsg);
  String printLoanData(){
    return "\nuid: $uid\nloanUid: $loanUid\nlenderPrId: $lenderPrId\nsubmitAmount: $submitAmount"
        "\nsubmitRate: $submitRate\ncompanyName: $companyName\ncompanyLogo: $companyLogo\nproductName: $productName\ncompanyCallNum: $contactNo"
        "\ncreatedDate: $createdDate\nupdatedDate: $updatedDate\nstatueId: $statueId\nchatRoomId: $chatRoomId";
  }

  static String getDetailStatusName(String statueId){
    String status = "";
    switch(statueId){
      case "1" : status = "접수중";
      case "2" : status = "심사중";
      case "3" : status = "대기중";
      case "4" : status = "승인완료";
      case "5" : status = "보류";
      case "6" : status = "부결";
      case "7" : status = "본인취소";
    }

    return status;
  }
  static String getStatusName(String statueId){
    String status = "";
    switch(statueId){
      case "1" : status = "접수";
      case "2" : status = "심사";
      case "3" : status = "심사";
      case "4" : status = "통보";
      case "5" : status = "통보";
      case "6" : status = "통보";
      case "7" : status = "통보";
    }

    return status;
  }
  static String getDisplayStatusName(String statueId){
    String status = "";
    switch(statueId){
      case "1" : status = "접수중";
      case "2" : status = "심사중";
      case "3" : status = "심사중";
      case "4" : status = "승인";
      case "5" : status = "보류";
      case "6" : status = "부결";
      case "7" : status = "취소";
    }

    return status;
  }
}