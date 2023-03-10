class AfterLogin {
  ChallengeParameters? challengeParameters;
  AuthenticationResult? authenticationResult;
  UserDetails? userDetails;
  List<MasterData>? masterData;
  List<WardDetails>? wardDetails;
  List<GrievanceTypes>? grievanceTypes;

  AfterLogin(
      {this.challengeParameters,
      this.authenticationResult,
      this.userDetails,
      this.masterData,
      this.wardDetails,
      this.grievanceTypes});

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
    if (json['MasterData'] != null) {
      masterData = <MasterData>[];
      json['MasterData'].forEach((v) {
        masterData!.add(MasterData.fromJson(v));
      });
    }
    if (json['WardDetails'] != null) {
      wardDetails = <WardDetails>[];
      json['WardDetails'].forEach((v) {
        wardDetails!.add(WardDetails.fromJson(v));
      });
    }
    if (json['GrievanceTypes'] != null) {
      grievanceTypes = <GrievanceTypes>[];
      json['GrievanceTypes'].forEach((v) {
        grievanceTypes!.add(GrievanceTypes.fromJson(v));
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
      data['MasterData'] = masterData!.map((v) => v.toJson()).toList();
    }
    if (wardDetails != null) {
      data['WardDetails'] = wardDetails!.map((v) => v.toJson()).toList();
    }
    if (grievanceTypes != null) {
      data['GrievanceTypes'] = grievanceTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChallengeParameters {
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

  AuthenticationResult(
      {this.accessToken,
      this.expiresIn,
      this.tokenType,
      this.refreshToken,
      this.idToken});

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
  bool? active;
  String? lastName;
  String? municipalityID;
  List<AllocatedWards>? allocatedWards;

  UserDetails(
      {this.mobileNumber,
      this.emailID,
      this.profilePicture,
      this.role,
      this.staffID,
      this.notificationToken,
      this.createdBy,
      this.firstName,
      this.active,
      this.lastName,
      this.municipalityID,
      this.allocatedWards});

  UserDetails.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'];
    emailID = json['EmailID'];
    profilePicture = json['ProfilePicture'];
    role = json['Role'];
    staffID = json['StaffID'];
    notificationToken = json['NotificationToken'];
    createdBy = json['CreatedBy'];
    firstName = json['FirstName'];
    active = json['Active'];
    lastName = json['LastName'];
    municipalityID = json['MunicipalityID'];
    if (json['allocatedWards'] != null) {
      allocatedWards = <AllocatedWards>[];
      json['allocatedWards'].forEach((v) {
        allocatedWards!.add(AllocatedWards.fromJson(v));
      });
    }
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
    data['Active'] = active;
    data['LastName'] = lastName;
    data['MunicipalityID'] = municipalityID;
    if (allocatedWards != null) {
      data['allocatedWards'] = allocatedWards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllocatedWards {
  String? grievanceType;
  List<String>? wardNumber;

  AllocatedWards({this.grievanceType, this.wardNumber});

  AllocatedWards.fromJson(Map<String, dynamic> json) {
    grievanceType = json['grievanceType'];
    wardNumber = json['wardNumber'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['grievanceType'] = grievanceType;
    data['wardNumber'] = wardNumber;
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

class WardDetails {
  bool? active;
  String? wardName;
  String? wardNumber;
  String? municipalityID;

  WardDetails(
      {this.active, this.wardName, this.wardNumber, this.municipalityID});

  WardDetails.fromJson(Map<String, dynamic> json) {
    active = json['Active'];
    wardName = json['WardName'];
    wardNumber = json['WardNumber'];
    municipalityID = json['MunicipalityID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Active'] = active;
    data['WardName'] = wardName;
    data['WardNumber'] = wardNumber;
    data['MunicipalityID'] = municipalityID;
    return data;
  }
}

class GrievanceTypes {
  String? municipalityID;
  List<MuicipalityGrievances>? grievances;

  GrievanceTypes({this.municipalityID, this.grievances});

  GrievanceTypes.fromJson(Map<String, dynamic> json) {
    municipalityID = json['MunicipalityID'];
    if (json['Grievances'] != null) {
      grievances = <MuicipalityGrievances>[];
      json['Grievances'].forEach((v) {
        grievances!.add(MuicipalityGrievances.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MunicipalityID'] = municipalityID;
    if (grievances != null) {
      data['Grievances'] = grievances!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MuicipalityGrievances {
  String? grievanceType;
  String? grievanceTypeName;

  MuicipalityGrievances({this.grievanceType, this.grievanceTypeName});

  MuicipalityGrievances.fromJson(Map<String, dynamic> json) {
    grievanceType = json['GrievanceType'];
    grievanceTypeName = json['GrievanceTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GrievanceType'] = grievanceType;
    data['GrievanceTypeName'] = grievanceTypeName;
    return data;
  }
}
