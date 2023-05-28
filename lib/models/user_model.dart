class User {
  String? userId;
  String? about;
  bool? active;
  String? address;
  String? countryCode;
  String? staffId;
  String? createdDate;
  String? emailId;
  String? firstName;
  String? lastModifiedDate;
  String? lastName;
  String? mobileNumber;
  String? municipalityId;
  String? notificationToken;
  String? profilePicture;
  String? latitude;
  String? longitude;
  String? wardNumber;

  User({
    this.about,
    this.active,
    this.address,
    this.countryCode,
    this.staffId,
    this.createdDate,
    this.emailId,
    this.firstName,
    this.lastModifiedDate,
    this.lastName,
    this.mobileNumber,
    this.municipalityId,
    this.notificationToken,
    this.profilePicture,
    this.latitude,
    this.longitude,
    this.wardNumber,
    this.userId,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['UserID'];
    about = json['About'];
    active = json['Active'];
    address = json['Address'];
    countryCode = json['CountryCode'];
    staffId = json['StaffId'];
    createdDate = json['CreatedDate'];
    emailId = json['EmailID'];
    firstName = json['FirstName'];
    lastModifiedDate = json['LastModifiedDate'];
    lastName = json['LastName'];
    mobileNumber = json['MobileNumber'];
    municipalityId = json['MunicipalityID'];
    notificationToken = json['NotificationToken'];
    profilePicture = json['ProfilePicture'];
    latitude = json['UserLatitude'];
    longitude = json['UserLongitude'];
    wardNumber = json['UserWardNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserID'] = userId;
    data['About'] = about;
    data['Active'] = active;
    data['Address'] = address;
    data['CountryCode'] = countryCode;
    data['StaffID'] = staffId;
    data['CreatedDate'] = createdDate;
    data['EmailID'] = emailId;
    data['FirstName'] = firstName;
    data['LastModifiedDate'] = lastModifiedDate;
    data['LastName'] = lastName;
    data['MobileNumber'] = mobileNumber;
    data['MunicipalityID'] = municipalityId;
    data['NotificationToken'] = notificationToken;
    data['ProfilePicture'] = profilePicture;
    data['UserLatitude'] = latitude;
    data['UserLongitude'] = longitude;
    data['UserWardNumber'] = wardNumber;
    return data;
  }
}
