import 'package:hive/hive.dart';

part 'EventModel.g.dart';

@HiveType(typeId: 1)
class EventModel {
  @HiveField(0)
  int? id;

  EventModel({this.id});

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
