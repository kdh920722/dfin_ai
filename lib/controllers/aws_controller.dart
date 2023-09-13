import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import '../utils/common_utils.dart';

class AwsController {
  static final AwsController _instance = AwsController._internal();
  factory AwsController() => _instance;
  AwsController._internal();

  static String awsAccessKey = "";
  static String awsSecretKey = "";
  static String awsRegion = "";
  static String bucket = "";
  static String maskedImageDir = "";

  static Future<void> initAWS(Function(bool isSuccess) callback) async{
    try{
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('UPFIN/API/aws').get();
      if (snapshot.exists) {
        for(var each in snapshot.children){
          switch(each.key){
            case "access_key" : awsAccessKey = each.value.toString();
            case "secret_key" : awsSecretKey = each.value.toString();
            case "region" : awsRegion = each.value.toString();
            case "bucket" : bucket = each.value.toString();
            case "masked_img_dir" : maskedImageDir = each.value.toString();
          }
        }
        callback(true);
      } else {
        callback(false);
      }
    }catch(e){
      CommonUtils.log("e", "aws get access_key error : ${e.toString()}");
      callback(false);
    }
  }

  static Future<void> uploadImageToAWS(String filePath, Function(bool isSuccess, String resultUrl) callback) async {
    try{
      String? result = await AwsS3.uploadFile(
          accessKey: awsAccessKey,
          secretKey: awsSecretKey,
          file: File(filePath),
          bucket: bucket,
          region: awsRegion,
          destDir: maskedImageDir,
          metadata: {"test": "test"} // optional
      );
      if(result != null){
        CommonUtils.log('i', 'aws s3 result : $result');
        return callback(true, result);
      }else{
        CommonUtils.log('e', 'aws s3 result is null');
        return callback(false, "");
      }
    }catch(e){
      CommonUtils.log('e', e.toString());
      return callback(false, "");
    }



  }

}