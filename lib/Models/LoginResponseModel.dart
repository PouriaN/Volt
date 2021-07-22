
class LoginResponseModel {
  String? authorization;
  String? message;
  int? userId;

  LoginResponseModel({this.authorization, this.message, this.userId});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    authorization = json['Authorization'];
    message = json['message'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Authorization'] = this.authorization;
    data['message'] = this.message;
    data['userId'] = this.userId;
    return data;
  }
}
