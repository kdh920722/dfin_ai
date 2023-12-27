class CarInfoData {
  String id;
  String carUid;
  String carNum;
  String carOwnerName;
  String carPrice;
  String carLendCount;
  String carLendAmount;
  String carWishAmount;
  String date;
  Map<String, dynamic> resData;

  CarInfoData(this.id, this.carUid, this.carNum, this.carOwnerName, this.carPrice,
      this.carLendCount, this.carLendAmount, this.carWishAmount, this.date, this.resData);
}