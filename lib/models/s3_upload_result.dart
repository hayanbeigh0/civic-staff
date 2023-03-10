class S3UploadResult {
  String? message;
  UploadResult? uploadResult;

  S3UploadResult({this.message, this.uploadResult});

  S3UploadResult.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    uploadResult = json['uploadResult'] != null
        ? UploadResult.fromJson(json['uploadResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (uploadResult != null) {
      data['uploadResult'] = uploadResult!.toJson();
    }
    return data;
  }
}

class UploadResult {
  String? eTag;
  String? serverSideEncryption;
  String? location;
  String? key1;
  String? key2;
  String? bucket;
  String? presignedUrl;

  UploadResult({
    this.eTag,
    this.serverSideEncryption,
    this.location,
    this.key1,
    this.key2,
    this.bucket,
    this.presignedUrl,
  });

  UploadResult.fromJson(Map<String, dynamic> json) {
    eTag = json['ETag'];
    serverSideEncryption = json['ServerSideEncryption'];
    location = json['Location'];
    key1 = json['key'];
    key2 = json['Key'];
    bucket = json['Bucket'];
    presignedUrl = json['presigned_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ETag'] = eTag;
    data['ServerSideEncryption'] = serverSideEncryption;
    data['Location'] = location;
    data['key'] = key1;
    data['Key'] = key2;
    data['Bucket'] = bucket;
    data['presigned_url'] = presignedUrl;
    return data;
  }
}
