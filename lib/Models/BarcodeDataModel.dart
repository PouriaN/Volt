import 'package:hive/hive.dart';

part 'BarcodeDataModel.g.dart';

@HiveType(typeId: 0)
class BarcodeDataModel {
  @HiveField(0)
  int? competitorId;
  @HiveField(1)
  int? eventId;
  @HiveField(2)
  int? userId;
  @HiveField(3)
  String? date;

  BarcodeDataModel({this.competitorId, this.eventId, this.userId, this.date});

  BarcodeDataModel.fromJson(Map<String, dynamic> json) {
    competitorId = json['competitorId'];
    eventId = json['eventId'];
    userId = json['userId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['competitorId'] = this.competitorId;
    data['eventId'] = this.eventId;
    data['userId'] = this.userId;
    data['date'] = this.date;
    return data;
  }
}
