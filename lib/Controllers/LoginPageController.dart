import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:racing_manager/Models/LoginResponseModel.dart';
import 'package:racing_manager/Resources/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LoginPageStates {}

class LoginPageStateInitial extends LoginPageStates {}
class LoginPageStateGetLoggedIn extends LoginPageStates {}
class LoginPageStateLoading extends LoginPageStates {}

class LoginPageController extends Cubit<LoginPageStates> {
  LoginPageController() : super(LoginPageStateInitial());

  late LoginResponseModel loginResponseModel;
  late final SharedPreferences shPrefs;

  Future<bool> checkForLogin() async {
    shPrefs = await SharedPreferences.getInstance();
    if (shPrefs.getBool("isLoggedIn") != null &&
        shPrefs.getBool("isLoggedIn")!) {
      loginResponseModel = getLoginDetails();
      return true;
    } else {
      shPrefs.setBool("isLoggedIn", false);
      return false;
    }
  }

  LoginResponseModel getLoginDetails() => LoginResponseModel.fromJson(
      jsonDecode(shPrefs.getString("LoginDetail")!));

  void setLoginDetails(String username, String password) async {
    emit(LoginPageStateLoading());
    var client = http.Client();
    Map<String, String> requestHeaders = {'Content-type': 'Application/json'};
    Response response = await client.post(
        Uri(
            host: API_BASE_URL,
            path: "/auth/login/",
            port: SERVER_PORT,
            scheme: REQUEST_SCHEME),
        headers: requestHeaders,
        body: jsonEncode({"username": username, "password": password}));
    emit(LoginPageStateInitial());
    if (response.statusCode == 200) {
      loginResponseModel =
          LoginResponseModel.fromJson(jsonDecode(response.body));
      shPrefs.setString("LoginDetail", jsonEncode(loginResponseModel.toJson()));
      shPrefs.setBool("isLoggedIn", true);
      emit(LoginPageStateGetLoggedIn());
    }
  }

  Future<void> logOut() async {
    await shPrefs.setBool("isLoggedIn", false);
    await shPrefs.remove("LoginDetail");
    return;
  }
}
