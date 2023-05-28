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
  String? createdDate;
  String? lastModifiedDate;
  String? location;
  String? createdBy;
  bool? mobileContactStatus;
  String? wardNumber;
  Assets? assets;
  String? grievanceType;
  String? newHouseAddress;
  String? planDetails;
  String? deceasedName;
  String? relation;
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
    this.newHouseAddress,
    this.planDetails,
    this.deceasedName,
    this.relation,
    this.createdDate,
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
    createdDate = json['CreatedDate'];
    mobileContactStatus = json['MobileContactStatus'];
    wardNumber = json['WardNumber'];
    assets = json['Assets'] != null ? Assets.fromJson(json['Assets']) : null;
    grievanceType = json['GrievanceType'];
    newHouseAddress = json['NewHouseAddress'];
    planDetails = json['PlanDetails'];
    deceasedName = json['DeceasedName'];
    relation = json['Relation'];
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
    data['CreatedDate'] = createdDate;
    data['MobileContactStatus'] = mobileContactStatus;
    data['WardNumber'] = wardNumber;
    data['NewHouseAddress'] = newHouseAddress;
    data['PlanDetails'] = planDetails;
    data['DeceasedName'] = deceasedName;
    data['Relation'] = relation;
    if (assets != null) {
      data['Assets'] = assets!.toJson();
    }
    data['GrievanceType'] = grievanceType;
    if (comments != null) {
      data['Comments'] = comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Assets {
  List<String>? audio;
  List<String>? image;
  List<String>? video;

  Assets({this.audio, this.image, this.video});

  Assets.fromJson(Map<String, dynamic> json) {
    audio = json['Audio'] != null ? json['Audio'].cast<String>() : null;
    image = json['Image'] != null ? json['Image'].cast<String>() : null;
    video = json['Video'] != null ? json['Video'].cast<String>() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Audio'] = audio;
    data['Image'] = image;
    data['Video'] = video;
    return data;
  }
}

class Comments {
  String? commentedBy;
  String? comment;
  String? grievanceID;
  String? createdDate;
  String? commentID;
  String? commentedByName;
  Assets? assets;

  Comments(
      {this.commentedBy,
      this.comment,
      this.grievanceID,
      this.createdDate,
      this.commentID,
      this.commentedByName,
      this.assets});

  Comments.fromJson(Map<String, dynamic> json) {
    commentedBy = json['CommentedBy'];
    comment = json['Comment'];
    grievanceID = json['GrievanceID'];
    createdDate = json['CreatedDate'];
    commentID = json['CommentID'];
    commentedByName = json['CommentedByName'];
    assets = json['Assets'] != null ? Assets.fromJson(json['Assets']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CommentedBy'] = commentedBy;
    data['Comment'] = comment;
    data['GrievanceID'] = grievanceID;
    data['CreatedDate'] = createdDate;
    data['CommentID'] = commentID;
    data['CommentedByName'] = commentedByName;
    if (assets != null) {
      data['Assets'] = assets!.toJson();
    }
    return data;
  }
}
