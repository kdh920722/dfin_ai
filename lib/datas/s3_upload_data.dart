class S3UploadData {
  final String url;
  final Map<String, String> fields;

  S3UploadData({
    required this.url,
    required this.fields,
  });

  factory S3UploadData.fromJson(Map<String, dynamic> json) {
    return S3UploadData(
      url: json['url'],
      fields: Map<String, String>.from(json['fields']),
    );
  }
}