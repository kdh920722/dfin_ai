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
  String carModel;
  String carModelDetail;
  String carImage;
  Map<String, dynamic> regAData;
  Map<String, dynamic> resData;

  CarInfoData(this.id, this.carUid, this.carNum, this.carOwnerName, this.carPrice,
      this.carLendCount, this.carLendAmount, this.carWishAmount, this.date, this.carModel, this.carModelDetail, this.carImage, this.regAData, this.resData);
}