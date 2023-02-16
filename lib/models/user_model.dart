class User {
  String? id;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? latitude;
  String? longitude;
  String? streetName;
  String? city;
  String? country;
  String? muncipality;
  String? wardNumber;
  String? email;
  String? about;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.latitude,
    this.longitude,
    this.streetName,
    this.city,
    this.country,
    this.wardNumber,
    this.email,
    this.about,
    this.muncipality,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    streetName = json['streetName'];
    city = json['city'];
    country = json['country'];
    muncipality = json['muncipality'];
    wardNumber = json['wardNumber'];
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobileNumber'] = mobileNumber;
    data['email'] = email;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['streetName'] = streetName;
    data['city'] = city;
    data['country'] = country;
    data['muncipality'] = muncipality;
    data['wardNumber'] = wardNumber;
    data['about'] = about;
    return data;
  }
}
