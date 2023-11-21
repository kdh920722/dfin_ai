import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http_parser/http_parser.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'dart:io';
import '../datas/s3_upload_data.dart';
import '../utils/common_utils.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

class AwsController {
  static final AwsController _instance = AwsController._internal();

  factory AwsController() => _instance;

  AwsController._internal();

  static String awsAccessKey = "";
  static String awsSecretKey = "";
  static String awsRegion = "";
  static String bucket = "";
  static String maskedImageDir = "";
  static String chatFilesDir = "";
  static String uploadedUrl = "";

  static Future<void> initAWS(Function(bool isSuccess) callback) async {
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('UPFIN/API/aws').get();
      if (snapshot.exists) {
        for (var each in snapshot.children) {
          switch (each.key) {
            case "access_key" :
              awsAccessKey = each.value.toString();
            case "secret_key" :
              awsSecretKey = each.value.toString();
            case "region" :
              awsRegion = each.value.toString();
            case "bucket" :
              bucket = each.value.toString();
            case "masked_img_dir" :
              maskedImageDir = each.value.toString();
            case "chat_files_dir" :
              chatFilesDir = each.value.toString();
            case "uploaded_url" :
              uploadedUrl = each.value.toString();
          }
        }
        callback(true);
      } else {
        callback(false);
      }
    } catch (e) {
      CommonUtils.log("e", "aws get access_key error : ${e.toString()}");
      callback(false);
    }
  }

  static Future<void> uploadFileToAWS(String filePath, String awsPath, Function(bool isSuccess, String resultUrl) callback) async {
    try{
      if(CommonUtils.containsKorean(filePath)){
        filePath = await CommonUtils.renameFile(filePath, "${CommonUtils.convertTimeToString(CommonUtils.getCurrentLocalTime())}_renameForKorean");
      }
      String? result = await AwsS3.uploadFile(
          accessKey: awsAccessKey,
          secretKey: awsSecretKey,
          file: File(filePath),
          bucket: bucket,
          region: awsRegion,
          destDir: awsPath,
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


/*
  static Future<void> uploadFileToS3(String filePath, String awsPath,
      Function(bool isSuccess, String resultUrl) callback) async {

    try{
      // Generate a unique key for the file
      String fileName = filePath.split('/').last;
       /*
       * /private/var/mobile/Containers/Data/Application/FFA33E43-F5EB-430E-8F9D-8B34216C2A3C/tmp/03711.pdf
       * */
      // Generate the S3 URL
      String s3Url = 'https://$bucket.s3-$awsRegion.amazonaws.com/$awsPath/$fileName';

      // Prepare the HTTP request
      var request = http.MultipartRequest('POST', Uri.parse(s3Url));

      // Set the AWS S3 headers
      request.headers['authorization'] = 'AWS $awsAccessKey:$awsSecretKey';

      String contentType = 'application/octet-stream'; // Default content type
      if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg') || filePath.endsWith('.png') || filePath.endsWith('.bmp')) {
        contentType = 'image/jpeg';
      } else if (filePath.endsWith('.xlsx') || filePath.endsWith('.xlsm') || filePath.endsWith('.xlsb')) {
        contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      } else if (filePath.endsWith('.pdf')) {
        contentType = 'application/pdf';
      } else if (filePath.endsWith('.doc')) {
        contentType = 'application/msword';
      } else if (filePath.endsWith('.xltx')) {
        contentType = 'application/vnd.openxmlformats-officedocument.spreadsheettemplate';
      } else if (filePath.endsWith('.txt') || filePath.endsWith('.csv')) {
        contentType = 'text/plain';
      } else if (filePath.endsWith('.hwp')) {
        contentType = 'application/x-hwp';
      } else if (filePath.endsWith('.heic') || filePath.endsWith('.heif')) {
        contentType = 'image/heif';
      }

      // Add the file to the request
      var file = File(filePath);
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      request.files.add(http.MultipartFile(
        'file',
        stream,
        length,
        filename: fileName,
        contentType: MediaType.parse(contentType), // Adjust content type based on your file type
      ));

      // Send the HTTP request and get the response
      var response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        callback(true, responseBody);
      } else {
        callback(false, "");
      }
    }catch(error){
      CommonUtils.log('e', error.toString());
      callback(false, "");
    }

  }

  static Future<void> uploadFileToS3_2(String filePath, String awsPath,
      Function(bool isSuccess, String resultUrl) callback) async {
    try{
      String fileName = filePath.split('/').last;
      //Network service should be injected in a real app
      NetworkService networkService = NetworkService();

      ///Sample data for uploadData, replace with your own data
      S3UploadData uploadData = S3UploadData(
        url: 'https://$bucket.s3.$awsRegion.amazonaws.com/$awsPath/',
        fields: {
          "key": awsSecretKey,
          "AWSAccessKeyId": awsAccessKey,
        },
      );

      final (selectedFileBytes, selectedFileName) = await CommonUtils.getFileBytesAndName(File(filePath));
      String resultUrl = await networkService.uploadToS3(
        uploadUrl: uploadData.url,
        data: uploadData.fields,
        fileAsBinary: selectedFileBytes,
        filename: selectedFileName,
      );

      CommonUtils.log('', "resultUrl : $resultUrl");
      if(resultUrl != ""){
        callback(true, resultUrl);
      }else{
        callback(false, "");
      }

    }catch(error){
      CommonUtils.log('e', error.toString());
      callback(false, "");
    }
  }
}

class NetworkService {
  Future<String> uploadToS3({
    required String uploadUrl,
    required Map<String, String> data,
    required List<int> fileAsBinary,
    required String filename,
  }) async {
    var multiPartFile = http.MultipartFile.fromBytes('file', fileAsBinary, filename: filename);
    var uri = Uri.parse(uploadUrl);
    var request = http.MultipartRequest('POST', uri)
      ..fields.addAll(data)
      ..files.add(multiPartFile);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 204) {
      String responseBody = await response.stream.bytesToString();
      return responseBody;
    }
    return "";
  }
}

*/
}
enum ACL {
  /// Owner gets FULL_CONTROL. No one else has access rights (default).
  private,

  /// Owner gets FULL_CONTROL. The AllUsers group (see Who is a grantee?) gets READ access.
  public_read,

  /// Owner gets FULL_CONTROL. The AllUsers group gets READ and WRITE access. Granting this on a bucket is generally not recommended.
  public_read_write,

  /// Owner gets FULL_CONTROL. Amazon EC2 gets READ access to GET an Amazon Machine Image (AMI) bundle from Amazon S3.
  aws_exec_read,

  /// Owner gets FULL_CONTROL. The AuthenticatedUsers group gets READ access.
  authenticated_read,

  /// Object owner gets FULL_CONTROL. Bucket owner gets READ access. If you specify this canned ACL when creating a bucket, Amazon S3 ignores it.
  bucket_owner_read,

  /// Both the object owner and the bucket owner get FULL_CONTROL over the object. If you specify this  dcanned ACL when creating a bucket, Amazon S3 ignores it.
  bucket_owner_full_control,

  /// The LogDelivery group gets WRITE and READ_ACP permissions on the bucket. For more information about logs
  log_delivery_write,
}

class Policy {
  String expiration;
  String region;
  ACL acl;
  String bucket;
  String key;
  String credential;
  String datetime;
  int maxFileSize;
  Map<String, dynamic>? metadata;

  Policy(
      this.key,
      this.bucket,
      this.datetime,
      this.expiration,
      this.credential,
      this.maxFileSize,
      this.acl, {
        this.region = 'us-east-2',
        this.metadata,
      });

  factory Policy.fromS3PresignedPost(
      String key,
      String bucket,
      String accessKeyId,
      int expiryMinutes,
      int maxFileSize,
      ACL acl, {
        String region = 'us-east-2',
        Map<String, dynamic>? metadata,
      }) {
    final datetime = SigV4.generateDatetime();
    final expiration = (DateTime.now())
        .add(Duration(minutes: expiryMinutes))
        .toUtc()
        .toString()
        .split(' ')
        .join('T');
    final cred =
        '$accessKeyId/${SigV4.buildCredentialScope(datetime, region, 's3')}';

    return Policy(
      key,
      bucket,
      datetime,
      expiration,
      cred,
      maxFileSize,
      acl,
      region: region,
      metadata: metadata,
    );
  }

  String encode() {
    final bytes = utf8.encode(toString());
    return base64.encode(bytes);
  }

  List<Map<String, String>> _convertMetadataToPolicyParams(
      Map<String, dynamic>? metadata) {
    final List<Map<String, String>> params = [];

    if (metadata != null) {
      for (var k in metadata.keys) {
        params.add({k: metadata[k]});
      }
    }

    return params;
  }

  @override
  String toString() {
    final metadataParams = _convertMetadataToPolicyParams(metadata);

    final payload = {
      "expiration": "${this.expiration}",
      "conditions": [
        {"bucket": "${this.bucket}"},
        ["starts-with", "\$key", "${this.key}"],
        ["starts-with", "\$Content-Type", ""],
        {"acl": "${aclToString(acl)}"},
        ["content-length-range", 1, this.maxFileSize],
        {"x-amz-credential": "${this.credential}"},
        {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
        {"x-amz-date": "${this.datetime}"},
      ],
    };

    // If there's metadata, add it to the list of conditions for the policy.
    if (metadataParams.isNotEmpty) {
      for (final p in metadataParams) {
        (payload['conditions'] as List).add(p);
      }
    }

    return jsonEncode(payload);
  }
}

String aclToString(ACL acl) {
  switch (acl) {
    case ACL.private:
      return 'private';
    case ACL.public_read:
      return 'public-read';
    case ACL.public_read_write:
      return 'public-read-write';
    case ACL.aws_exec_read:
      return 'aws-exec-read';
    case ACL.authenticated_read:
      return 'authenticated-read';
    case ACL.bucket_owner_read:
      return 'bucket-owner-read';
    case ACL.bucket_owner_full_control:
      return 'bucket-owner-full-control';
    case ACL.log_delivery_write:
      return 'log-delivery-write';
  }
}

class AwsS3 {
  /// Upload a file, returning the file's public URL on success.
  static Future<String?> uploadFile({
    /// AWS access key
    required String accessKey,

    /// AWS secret key
    required String secretKey,

    /// The name of the S3 storage bucket to upload  to
    required String bucket,

    /// The file to upload
    required File file,

    /// The key to save this file as. Will override destDir and filename if set.
    String? key,

    /// The path to upload the file to (e.g. "uploads/public"). Defaults to the root "directory"
    String destDir = '',

    /// The AWS region. Must be formatted correctly, e.g. us-west-1
    String region = 'us-east-2',

    /// Access control list enables you to manage access to bucket and objects
    /// For more information visit [https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html]
    ACL acl = ACL.public_read,

    /// The filename to upload as. If null, defaults to the given file's current filename.
    String? filename,

    /// The content-type of file to upload. defaults to binary/octet-stream.
    String contentType = 'binary/octet-stream',

    /// If set to true, https is used instead of http. Default is true.
    bool useSSL = true,

    /// Additional metadata to be attached to the upload
    Map<String, String>? metadata,
  }) async {
    var httpStr = 'http';
    if (useSSL) {
      httpStr += 's';
    }
    final endpoint = '$httpStr://$bucket.s3.$region.amazonaws.com';

    String? uploadKey;

    if (key != null) {
      uploadKey = key;
    } else if (destDir.isNotEmpty) {
      uploadKey = '$destDir/${filename ?? path.basename(file.path)}';
    } else {
      uploadKey = '${filename ?? path.basename(file.path)}';
    }

    final stream = http.ByteStream(Stream.castFrom(file.openRead()));
    final length = await file.length();

    final uri = Uri.parse(endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(file.path));

    // Convert metadata to AWS-compliant params before generating the policy.
    final metadataParams = _convertMetadataToParams(metadata);

    // Generate pre-signed policy.
    final policy = Policy.fromS3PresignedPost(
      uploadKey,
      bucket,
      accessKey,
      15,
      length,
      acl,
      region: region,
      metadata: metadataParams,
    );

    final signingKey =
    SigV4.calculateSigningKey(secretKey, policy.datetime, region, 's3');
    final signature = SigV4.calculateSignature(signingKey, policy.encode());

    req.files.add(multipartFile);
    req.fields['key'] = policy.key;
    req.fields['acl'] = aclToString(acl);
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;
    req.fields['Content-Type'] = contentType;

    // If metadata isn't null, add metadata params to the request.
    if (metadata != null) {
      req.fields.addAll(metadataParams);
    }

    try {
      final res = await req.send();

      if (res.statusCode == 204) return '$endpoint/$uploadKey';
    } catch (e) {
      print('Failed to upload to AWS, with exception:');
      print(e);
      return null;
    }
  }

  /// A method to transform the map keys into the format compliant with AWS.
  /// AWS requires that each metadata param be sent as `x-amz-meta-*`.
  static Map<String, String> _convertMetadataToParams(
      Map<String, String>? metadata) {
    Map<String, String> updatedMetadata = {};

    if (metadata != null) {
      for (var k in metadata.keys) {
        updatedMetadata['x-amz-meta-${k.paramCase}'] = metadata[k]!;
      }
    }

    return updatedMetadata;
  }
}