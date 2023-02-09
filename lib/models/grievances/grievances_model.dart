import 'package:equatable/equatable.dart';

class Grievances extends Equatable {
  String? grievanceId;
  String? grievanceType;
  String? raisedBy;
  String? status;
  String? priority;
  String? place;
  String? timeStamp;
  String? expectedCompletion;
  List<String>? photos;
  List<String>? audios;
  List<String>? videos;
  String? latitude;
  String? longitude;
  String? wardNumber;
  String? description;
  bool? contactByPhoneEnabled;
  bool? open;
  List<ReporterComments>? reporterComments;
  List<MyComments>? myComments;

  Grievances({
    this.grievanceId,
    this.grievanceType,
    this.raisedBy,
    this.status,
    this.priority,
    this.place,
    this.timeStamp,
    this.photos,
    this.audios,
    this.videos,
    this.latitude,
    this.longitude,
    this.wardNumber,
    this.description,
    this.contactByPhoneEnabled,
    this.reporterComments,
    this.myComments,
    this.open,
    this.expectedCompletion,
  });

  Grievances.fromJson(Map<String, dynamic> json) {
    expectedCompletion = json['expectedCompletion'];
    grievanceId = json['grievanceId'];
    open = json['open'];
    grievanceType = json['grievanceType'];
    raisedBy = json['raisedBy'];
    status = json['status'];
    priority = json['priority'];
    timeStamp = json['timeStamp'];
    photos = json['photos'].cast<String>();
    audios = json['audios'].cast<String>();
    videos = json['videos'].cast<String>();
    latitude = json['latitude'];
    longitude = json['longitude'];
    wardNumber = json['wardNumber'];
    description = json['description'];
    place = json['place'];
    contactByPhoneEnabled = json['contactByPhoneEnabled'];
    if (json['reporterComments'] != null) {
      reporterComments = <ReporterComments>[];
      json['reporterComments'].forEach((v) {
        reporterComments!.add(ReporterComments.fromJson(v));
      });
    }
    if (json['myComments'] != null) {
      myComments = <MyComments>[];
      json['myComments'].forEach((v) {
        myComments!.add(MyComments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expectedCompletion'] = expectedCompletion;
    data['grievanceId'] = grievanceId;
    data['open'] = open;
    data['grievanceType'] = grievanceType;
    data['raisedBy'] = raisedBy;
    data['status'] = status;
    data['priority'] = priority;
    data['timeStamp'] = timeStamp;
    data['photos'] = photos;
    data['audios'] = audios;
    data['videos'] = videos;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['wardNumber'] = wardNumber;
    data['description'] = description;
    data['place'] = place;
    data['contactByPhoneEnabled'] = contactByPhoneEnabled;
    if (reporterComments != null) {
      data['reporterComments'] =
          reporterComments!.map((v) => v.toJson()).toList();
    }
    if (myComments != null) {
      data['myComments'] = myComments!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object?> get props => [status];
}

class ReporterComments extends Equatable {
  String? text;
  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  String? timeStamp;

  ReporterComments({
    this.text,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
    this.timeStamp,
  });

  ReporterComments.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    imageUrl = json['imageUrl'];
    videoUrl = json['videoUrl'];
    audioUrl = json['audioUrl'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['imageUrl'] = imageUrl;
    data['videoUrl'] = videoUrl;
    data['audioUrl'] = audioUrl;
    data['timeStamp'] = timeStamp;
    return data;
  }

  @override
  List<Object?> get props => [];
}

class MyComments extends Equatable {
  String? text;
  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  String? timeStamp;

  MyComments({
    this.text,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
    this.timeStamp,
  });

  MyComments.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    imageUrl = json['imageUrl'];
    videoUrl = json['videoUrl'];
    audioUrl = json['audioUrl'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['imageUrl'] = imageUrl;
    data['videoUrl'] = videoUrl;
    data['audioUrl'] = audioUrl;
    data['timeStamp'] = timeStamp;
    return data;
  }

  @override
  List<Object?> get props => [];
}
