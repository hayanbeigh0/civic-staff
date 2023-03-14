import 'package:civic_staff/models/user_details.dart';
import 'package:equatable/equatable.dart';

class MyProfile extends Equatable {
  String? id;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  String? about;
  String? latitude;
  String? longitude;
  String? streetName;
  String? city;
  String? country;
  String? muncipality;
  String? profilePicture;
  List<AllocatedWards>? allocatedWards;

  MyProfile({
    this.id,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.email,
    this.about,
    this.latitude,
    this.longitude,
    this.streetName,
    this.city,
    this.country,
    this.allocatedWards,
    this.muncipality,
    this.profilePicture,
  });

  MyProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    about = json['about'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    streetName = json['streetName'];
    city = json['city'];
    country = json['country'];
    muncipality = json['muncipality'];
    profilePicture = json['profilePicture'];
    if (json['allocatedWards'] != null) {
      allocatedWards = <AllocatedWards>[];
      json['allocatedWards'].forEach((v) {
        allocatedWards!.add(AllocatedWards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobileNumber'] = mobileNumber;
    data['email'] = email;
    data['about'] = about;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['streetName'] = streetName;
    data['city'] = city;
    data['country'] = country;
    data['muncipality'] = muncipality;
    data['profilePicture'] = profilePicture;
    if (allocatedWards != null) {
      data['allocatedWards'] = allocatedWards!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        mobileNumber,
        email,
        about,
        latitude,
        longitude,
        streetName,
        city,
        country,
        muncipality,
        profilePicture,
      ];
}

// class AllocatedWards extends Equatable {
//   String? grievanceType;
//   List<String>? wardNumber;

//   AllocatedWards({this.grievanceType, this.wardNumber});

//   AllocatedWards.fromJson(Map<String, dynamic> json) {
//     grievanceType = json['grievanceType'];
//     wardNumber = json['wardNumber'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['grievanceType'] = grievanceType;
//     data['wardNumber'] = wardNumber;
//     return data;
//   }

//   @override
//   List<Object?> get props => [grievanceType, wardNumber];
// }
