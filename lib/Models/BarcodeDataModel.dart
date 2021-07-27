class BarcodeDataModel {
  int? competitorId;
  int? eventId;

  BarcodeDataModel({this.competitorId, this.eventId});

  BarcodeDataModel.fromJson(Map<String, dynamic> json) {
    competitorId = json['competitorId'];
    eventId = json['eventId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['competitorId'] = this.competitorId;
    data['eventId'] = this.eventId;
    return data;
  }
}
