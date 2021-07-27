import 'package:hive/hive.dart';

import 'EventModel.dart';

part 'BarcodeRecordModel.g.dart';

@HiveType(typeId: 0)
class BarcodeRecordModel {
  @HiveField(0)
  EventModel? event;
  @HiveField(1)
  EventModel? competitor;
  @HiveField(2)
  String? actualTime;

  BarcodeRecordModel({this.event, this.competitor, this.actualTime});

  BarcodeRecordModel.fromJson(Map<String, dynamic> json) {
    event = json['event'] != null ? new EventModel.fromJson(json['event']) : null;
    competitor = json['competitor'] != null
        ? new EventModel.fromJson(json['competitor'])
        : null;
    actualTime = json['actualTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event'] = this.event?.toJson();
    data['competitor'] = this.competitor?.toJson();
    data['actualTime'] = this.actualTime;
    return data;
  }
}
