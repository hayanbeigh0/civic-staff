class Grievances {
  String? createdByName;
  String? address;
  String? priority;
  String? locationLong;
  String? grievanceID;
  String? contactNumber;
  String? status;
  String? description;
  String? expectedCompletion;
  String? municipalityID;
  String? locationLat;
  String? assignedTo;
  String? createdDate;
  String? lastModifiedDate;
  String? location;
  bool? mobileContactStatus;
  String? createdBy;
  String? wardNumber;
  String? grievanceType;
  String? newHouseAddress;
  String? planDetails;
  String? deceasedName;
  String? relation;
  Map? assets;

  Grievances({
    this.createdByName,
    this.address,
    this.priority,
    this.locationLong,
    this.grievanceID,
    this.contactNumber,
    this.status,
    this.description,
    this.expectedCompletion,
    this.municipalityID,
    this.locationLat,
    this.assignedTo,
    this.lastModifiedDate,
    this.location,
    this.mobileContactStatus,
    this.createdBy,
    this.wardNumber,
    this.grievanceType,
    this.assets,
    this.newHouseAddress,
    this.planDetails,
    this.deceasedName,
    this.relation,
    this.createdDate,
  });

  Grievances.fromJson(Map<String, dynamic> json) {
    createdByName = json['CreatedByName'];
    address = json['Address'];
    priority = json['Priority'];
    locationLong = json['LocationLong'];
    grievanceID = json['GrievanceID'];
    contactNumber = json['ContactNumber'];
    status = json['Status'];
    description = json['Description'];
    expectedCompletion = json['ExpectedCompletion'];
    municipalityID = json['MunicipalityID'];
    locationLat = json['LocationLat'];
    assignedTo = json['AssignedTo'];
    lastModifiedDate = json['LastModifiedDate'];
    location = json['Location'];
    mobileContactStatus = json['MobileContactStatus'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    wardNumber = json['WardNumber'];
    grievanceType = json['GrievanceType'];
    assets = json['Assets'];
    newHouseAddress = json['NewHouseAddress'];
    planDetails = json['PlanDetails'];
    deceasedName = json['DeceasedName'];
    relation = json['Relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CreatedByName'] = createdByName;
    data['Address'] = address;
    data['Priority'] = priority;
    data['LocationLong'] = locationLong;
    data['GrievanceID'] = grievanceID;
    data['ContactNumber'] = contactNumber;
    data['Status'] = status;
    data['Description'] = description;
    data['ExpectedCompletion'] = expectedCompletion;
    data['MunicipalityID'] = municipalityID;
    data['LocationLat'] = locationLat;
    data['AssignedTo'] = assignedTo;
    data['LastModifiedDate'] = lastModifiedDate;
    data['Location'] = location;
    data['MobileContactStatus'] = mobileContactStatus;
    data['CreatedBy'] = createdBy;
    data['CreatedDate'] = createdDate;
    data['WardNumber'] = wardNumber;
    data['GrievanceType'] = grievanceType;
    data['Assets'] = assets;
    data['NewHouseAddress'] = newHouseAddress;
    data['PlanDetails'] = planDetails;
    data['DeceasedName'] = deceasedName;
    data['Relation'] = relation;
    return data;
  }
}
