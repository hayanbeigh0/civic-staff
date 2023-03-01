class AfterLogin {
  ChallengeParameters? challengeParameters;
  AuthenticationResult? authenticationResult;
  UserDetails? userDetails;
  List<MasterData>? masterData;

  AfterLogin({
    this.challengeParameters,
    this.authenticationResult,
    this.userDetails,
    this.masterData,
  });

  AfterLogin.fromJson(Map<String, dynamic> json) {
    challengeParameters = json['ChallengeParameters'] != null
        ? ChallengeParameters.fromJson(json['ChallengeParameters'])
        : null;
    authenticationResult = json['AuthenticationResult'] != null
        ? AuthenticationResult.fromJson(json['AuthenticationResult'])
        : null;
    userDetails = json['UserDetails'] != null
        ? UserDetails.fromJson(json['UserDetails'])
        : null;
    if (json['masterData'] != null) {
      masterData = <MasterData>[];
      json['masterData'].forEach((v) {
        masterData!.add(MasterData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (challengeParameters != null) {
      data['ChallengeParameters'] = challengeParameters!.toJson();
    }
    if (authenticationResult != null) {
      data['AuthenticationResult'] = authenticationResult!.toJson();
    }
    if (userDetails != null) {
      data['UserDetails'] = userDetails!.toJson();
    }
    if (masterData != null) {
      data['masterData'] = masterData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChallengeParameters {
  ChallengeParameters();

  ChallengeParameters.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class AuthenticationResult {
  String? accessToken;
  int? expiresIn;
  String? tokenType;
  String? refreshToken;
  String? idToken;

  AuthenticationResult({
    this.accessToken,
    this.expiresIn,
    this.tokenType,
    this.refreshToken,
    this.idToken,
  });

  AuthenticationResult.fromJson(Map<String, dynamic> json) {
    accessToken = json['AccessToken'];
    expiresIn = json['ExpiresIn'];
    tokenType = json['TokenType'];
    refreshToken = json['RefreshToken'];
    idToken = json['IdToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AccessToken'] = accessToken;
    data['ExpiresIn'] = expiresIn;
    data['TokenType'] = tokenType;
    data['RefreshToken'] = refreshToken;
    data['IdToken'] = idToken;
    return data;
  }
}

class UserDetails {
  String? mobileNumber;
  String? emailID;
  String? profilePicture;
  String? role;
  String? staffID;
  String? notificationToken;
  String? createdBy;
  String? firstName;
  String? lastName;
  bool? active;
  String? municipalityID;

  UserDetails({
    this.mobileNumber,
    this.emailID,
    this.profilePicture,
    this.role,
    this.staffID,
    this.notificationToken,
    this.createdBy,
    this.firstName,
    this.lastName,
    this.active,
    this.municipalityID,
  });

  UserDetails.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'];
    emailID = json['EmailID'];
    profilePicture = json['ProfilePicture'];
    role = json['Role'];
    staffID = json['StaffID'];
    notificationToken = json['NotificationToken'];
    createdBy = json['CreatedBy'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    active = json['Active'];
    municipalityID = json['MunicipalityID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MobileNumber'] = mobileNumber;
    data['EmailID'] = emailID;
    data['ProfilePicture'] = profilePicture;
    data['Role'] = role;
    data['StaffID'] = staffID;
    data['NotificationToken'] = notificationToken;
    data['CreatedBy'] = createdBy;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['Active'] = active;
    data['MunicipalityID'] = municipalityID;
    return data;
  }
}

class MasterData {
  String? sK;
  String? pK;
  bool? active;
  String? name;

  MasterData({this.sK, this.pK, this.active, this.name});

  MasterData.fromJson(Map<String, dynamic> json) {
    sK = json['SK'];
    pK = json['PK'];
    active = json['Active'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SK'] = sK;
    data['PK'] = pK;
    data['Active'] = active;
    data['Name'] = name;
    return data;
  }
}
