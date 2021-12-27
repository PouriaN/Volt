import 'package:hive/hive.dart';

part 'ReportModel.g.dart';

@HiveType(typeId: 2)
class ReportModel {
  @HiveField(0)
  int? competitorNumber;
  @HiveField(1)
  String? description;
  @HiveField(2)
  String? type;
  @HiveField(3)
  String? time;

  ReportModel({this.time, this.description, this.competitorNumber, this.type});

  ReportModel.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    description = json['description'];
    competitorNumber = json['competitorNumber'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['description'] = this.description;
    data['competitorNumber'] = this.competitorNumber;
    data['type'] = this.type;
    return data;
  }
}
