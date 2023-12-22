class CarInfoData {
  String id;
  String carUid;
  String carNum;
  String carOwnerName;
  String carPrice;
  String accidentLendCount;
  String accidentLendAmount;
  String accidentWishAmount;
  String date;
  Map<String, dynamic> resData;

  CarInfoData(this.id, this.carUid, this.carNum, this.carOwnerName, this.carPrice,
      this.accidentLendCount, this.accidentLendAmount, this.accidentWishAmount, this.date, this.resData);
}