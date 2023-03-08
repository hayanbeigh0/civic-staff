class GrievanceDetail {
  String? createdByName;
  String? address;
  String? priority;
  String? locationLong;
  String? grievanceID;
  String? contactNumber;
  String? description;
  String? expectedCompletion;
  String? status;
  String? locationLat;
  String? municipalityID;
  String? lastModifiedDate;
  String? location;
  String? createdBy;
  bool? mobileContactStatus;
  String? wardNumber;
  Map? assets;
  String? grievanceType;
  List<Comments>? comments;

  GrievanceDetail({
    this.createdByName,
    this.address,
    this.priority,
    this.locationLong,
    this.grievanceID,
    this.contactNumber,
    this.description,
    this.expectedCompletion,
    this.status,
    this.locationLat,
    this.municipalityID,
    this.lastModifiedDate,
    this.location,
    this.createdBy,
    this.mobileContactStatus,
    this.wardNumber,
    this.assets,
    this.grievanceType,
    this.comments,
  });

  GrievanceDetail.fromJson(Map<String, dynamic> json) {
    createdByName = json['CreatedByName'];
    address = json['Address'];
    priority = json['Priority'];
    locationLong = json['LocationLong'];
    grievanceID = json['GrievanceID'];
    contactNumber = json['ContactNumber'];
    description = json['Description'];
    expectedCompletion = json['ExpectedCompletion'];
    status = json['Status'];
    locationLat = json['LocationLat'];
    municipalityID = json['MunicipalityID'];
    lastModifiedDate = json['LastModifiedDate'];
    location = json['Location'];
    createdBy = json['CreatedBy'];
    mobileContactStatus = json['MobileContactStatus'];
    wardNumber = json['WardNumber'];
    assets = json['Assets'];
    // assets = (json['Assets'] != null
    //     ? GrievanceAssets.fromJson(json['Assets'])
    //     : null) as Map?;
    grievanceType = json['GrievanceType'];
    if (json['Comments'] != null) {
      comments = <Comments>[];
      json['Comments'].forEach((v) {
        comments!.add(Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CreatedByName'] = createdByName;
    data['Address'] = address;
    data['Priority'] = priority;
    data['LocationLong'] = locationLong;
    data['GrievanceID'] = grievanceID;
    data['ContactNumber'] = contactNumber;
    data['Description'] = description;
    data['ExpectedCompletion'] = expectedCompletion;
    data['Status'] = status;
    data['LocationLat'] = locationLat;
    data['MunicipalityID'] = municipalityID;
    data['LastModifiedDate'] = lastModifiedDate;
    data['Location'] = location;
    data['CreatedBy'] = createdBy;
    data['MobileContactStatus'] = mobileContactStatus;
    data['WardNumber'] = wardNumber;
    if (assets != null) {
      data['Assets'] = assets!;
    }
    data['GrievanceType'] = grievanceType;
    if (comments != null) {
      data['Comments'] = comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GrievanceAssets {
  GrievanceAssets.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class Comments {
  String? commentedBy;
  String? comment;
  String? createdDate;
  String? grievanceID;
  String? commentID;
  String? commentedByName;
  Assets? assets;

  Comments({
    this.commentedBy,
    this.comment,
    this.createdDate,
    this.grievanceID,
    this.commentID,
    this.commentedByName,
    this.assets,
  });

  Comments.fromJson(Map<String, dynamic> json) {
    commentedBy = json['CommentedBy'];
    comment = json['Comment'];
    createdDate = json['CreatedDate'];
    grievanceID = json['GrievanceID'];
    commentID = json['CommentID'];
    commentedByName = json['CommentedByName'];
    assets = json['Assets'] != null ? Assets.fromJson(json['Assets']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CommentedBy'] = commentedBy;
    data['Comment'] = comment;
    data['CreatedDate'] = createdDate;
    data['GrievanceID'] = grievanceID;
    data['CommentID'] = commentID;
    data['CommentedByName'] = commentedByName;
    if (assets != null) {
      data['Assets'] = assets!.toJson();
    }
    return data;
  }
}

class Assets {
  Audio? audio;
  Audio? image;
  Audio? video;

  Assets({this.audio, this.image, this.video});

  Assets.fromJson(Map<String, dynamic> json) {
    audio = json['Audio'] != null ? Audio.fromJson(json['Audio']) : null;
    image = json['Image'] != null ? Audio.fromJson(json['Image']) : null;
    video = json['Video'] != null ? Audio.fromJson(json['Video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (audio != null) {
      data['Audio'] = audio!.toJson();
    }
    if (image != null) {
      data['Image'] = image!.toJson();
    }
    if (video != null) {
      data['Video'] = video!.toJson();
    }
    return data;
  }
}

class Audio {
  List<L>? l;

  Audio({this.l});

  Audio.fromJson(Map<String, dynamic> json) {
    if (json['L'] != null) {
      l = <L>[];
      json['L'].forEach((v) {
        l!.add(L.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (l != null) {
      data['L'] = l!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class L {
  String? s;

  L({this.s});

  L.fromJson(Map<String, dynamic> json) {
    s = json['S'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['S'] = s;
    return data;
  }
}
