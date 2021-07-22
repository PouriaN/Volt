import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:racing_manager/Models/BarcodeDataModel.dart';
import 'package:racing_manager/Resources/Constants.dart';
import 'package:racing_manager/Resources/Strings.dart';

abstract class MainPageStates {}

class MainPageStateInitial extends MainPageStates {}
class MainPageStateLoading extends MainPageStates {}

class MainPageStateShowDialog extends MainPageStates {}

class MainPageStateShowSnack extends MainPageStates {
  final String message;
  MainPageStateShowSnack({required this.message});
}

class MainPageController extends Cubit<MainPageStates> {
  MainPageController() : super(MainPageStateInitial()) {
    readDatabase();
  }

  void readDatabase() async {
    await Hive.openBox<BarcodeDataModel>(BARCODE_BOX);
  }

  void showScanDialog() => emit(MainPageStateShowDialog());

  void gotNewScan(String barcodeData, int userId) async {
    BarcodeDataModel barcode =
        BarcodeDataModel.fromJson(jsonDecode(barcodeData));
    barcode.date = DateTime.now().toString();
    barcode.userId = userId;
    await Hive.box<BarcodeDataModel>(BARCODE_BOX).add(barcode);
    emit(MainPageStateShowSnack(message: strBarcodeAddedSuccessfully));
  }

  void sendDataForServer(String token) async {
    emit(MainPageStateShowSnack(message: strSendingDataToServer));
    emit(MainPageStateLoading());
    //TODO: change url and check port
    var client = http.Client();
    Map<String, String> requestHeaders = {
      'Content-type': 'Application/json',
      "Authorization": token
    };
    Hive.box<BarcodeDataModel>(BARCODE_BOX).values.forEach((barcode) async {
      Response response = await client.post(
          Uri(
              host: API_BASE_URL,
              path: "/auth/login/",
              port: 8090,
              scheme: "http"),
          headers: requestHeaders,
          body: jsonEncode(barcode.toJson()));
      if (response.statusCode == 200) {
        print("here");
      }
    });
    emit(MainPageStateInitial());
    emit(MainPageStateShowSnack(message: strAllBarcodeSentSuccessfully));
  }
}
