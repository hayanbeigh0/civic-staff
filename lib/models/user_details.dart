class AfterLogin {
  ChallengeParameters? challengeParameters;
  AuthenticationResult? authenticationResult;
  UserDetails? userDetails;
  List<MasterData>? masterData;
  List<WardDetails>? wardDetails;
  GrievanceTypes? grievanceTypes;

  AfterLogin({
    this.challengeParameters,
    this.authenticationResult,
    this.userDetails,
    this.masterData,
    this.wardDetails,
    this.grievanceTypes,
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
    grievanceTypes = json['GrievanceTypes'] != null
        ? GrievanceTypes.fromJson(json['GrievanceTypes'])
        : null;
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
      data['GrievanceTypes'] = grievanceTypes!.toJson();
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
  bool? active;
  String? lastName;
  String? municipalityID;
  List<AllocatedWards>? allocatedWards;

  UserDetails({
    this.mobileNumber,
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
    this.allocatedWards,
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

  MasterData({
    this.sK,
    this.pK,
    this.active,
    this.name,
  });

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

  WardDetails({
    this.active,
    this.wardName,
    this.wardNumber,
    this.municipalityID,
  });

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
  List<MUNCIBd3cdc1aC2f540b6A76eAe85c26ec1a8>?
      mUNCIBd3cdc1aC2f540b6A76eAe85c26ec1a8;
  List<MUNCI647600d02e6e4bc28bb15b7edcf5a301>?
      mUNCI647600d02e6e4bc28bb15b7edcf5a301;
  List<MUNCI1>? mUNCI1;

  GrievanceTypes({
    this.mUNCIBd3cdc1aC2f540b6A76eAe85c26ec1a8,
    this.mUNCI647600d02e6e4bc28bb15b7edcf5a301,
    this.mUNCI1,
  });

  GrievanceTypes.fromJson(Map<String, dynamic> json) {
    if (json['MUNCI-bd3cdc1a-c2f5-40b6-a76e-ae85c26ec1a8'] != null) {
      mUNCIBd3cdc1aC2f540b6A76eAe85c26ec1a8 =
          <MUNCIBd3cdc1aC2f540b6A76eAe85c26ec1a8>[];
      json['MUNCI-bd3cdc1a-c2f5-40b6-a76e-ae85c26ec1a8'].forEach((v) {
        mUNCIBd3cdc1aC2f540b6A76eAe85c26ec1a8!
            .add(MUNCIBd3cdc1aC2f540b6A76eAe85c26ec1a8.fromJson(v));
      });
    }
    if (json['MUNCI-647600d0-2e6e-4bc2-8bb1-5b7edcf5a301'] != null) {
      mUNCI647600d02e6e4bc28bb15b7edcf5a301 =
          <MUNCI647600d02e6e4bc28bb15b7edcf5a301>[];
      json['MUNCI-647600d0-2e6e-4bc2-8bb1-5b7edcf5a301'].forEach((v) {
        mUNCI647600d02e6e4bc28bb15b7edcf5a301!
            .add(MUNCI647600d02e6e4bc28bb15b7edcf5a301.fromJson(v));
      });
    }
    if (json['MUNCI-1'] != null) {
      mUNCI1 = <MUNCI1>[];
      json['MUNCI-1'].forEach((v) {
        mUNCI1!.add(MUNCI1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mUNCIBd3cdc1aC2f540b6A76eAe85c26ec1a8 != null) {
      data['MUNCI-bd3cdc1a-c2f5-40b6-a76e-ae85c26ec1a8'] =
          mUNCIBd3cdc1aC2f540b6A76eAe85c26ec1a8!
              .map((v) => v.toJson())
              .toList();
    }
    if (mUNCI647600d02e6e4bc28bb15b7edcf5a301 != null) {
      data['MUNCI-647600d0-2e6e-4bc2-8bb1-5b7edcf5a301'] =
          mUNCI647600d02e6e4bc28bb15b7edcf5a301!
              .map((v) => v.toJson())
              .toList();
    }
    if (mUNCI1 != null) {
      data['MUNCI-1'] = mUNCI1!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MUNCIBd3cdc1aC2f540b6A76eAe85c26ec1a8 {
  String? grievanceType;
  String? grievanceTypeName;

  MUNCIBd3cdc1aC2f540b6A76eAe85c26ec1a8({
    this.grievanceType,
    this.grievanceTypeName,
  });

  MUNCIBd3cdc1aC2f540b6A76eAe85c26ec1a8.fromJson(Map<String, dynamic> json) {
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

class MUNCI647600d02e6e4bc28bb15b7edcf5a301 {
  String? grievanceType;
  String? grievanceTypeName;

  MUNCI647600d02e6e4bc28bb15b7edcf5a301({
    this.grievanceType,
    this.grievanceTypeName,
  });

  MUNCI647600d02e6e4bc28bb15b7edcf5a301.fromJson(Map<String, dynamic> json) {
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

class MUNCI1 {
  String? grievanceType;
  String? grievanceTypeName;

  MUNCI1({
    this.grievanceType,
    this.grievanceTypeName,
  });

  MUNCI1.fromJson(Map<String, dynamic> json) {
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
