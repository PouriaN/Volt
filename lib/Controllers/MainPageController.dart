import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:racing_manager/Models/BarcodeDataModel.dart';
import 'package:racing_manager/Models/BarcodeRecordModel.dart';
import 'package:racing_manager/Models/EventModel.dart';
import 'package:racing_manager/Models/ReportModel.dart';
import 'package:racing_manager/Resources/Constants.dart';
import 'package:racing_manager/Resources/Strings.dart';

abstract class MainPageStates {}

class MainPageStateInitial extends MainPageStates {}

class MainPageStateLoading extends MainPageStates {}

class MainPageStateShowScanDialog extends MainPageStates {}

class MainPageStateShowMessageDialog extends MainPageStates {
  final String message;
  final Color? messageColor;

  MainPageStateShowMessageDialog({this.messageColor, required this.message});
}

class MainPageController extends Cubit<MainPageStates> {
  MainPageController() : super(MainPageStateInitial()) {
    readDatabase();
  }

  void readDatabase() async {
    await Hive.openBox<BarcodeRecordModel>(BARCODE_BOX);
    await Hive.openBox<ReportModel>(REPORT_BOX);
  }

  void showScanDialog() => emit(MainPageStateShowScanDialog());

  void gotNewScan(String barcodeData, int userId, String token) async {
    BarcodeDataModel barcode =
        BarcodeDataModel.fromJson(jsonDecode(barcodeData));

    BarcodeRecordModel barcodeRecord = BarcodeRecordModel(
      actualTime: DateTime.now().toIso8601String(),
      competitor: EventModel(id: barcode.competitorId),
      event: EventModel(id: barcode.eventId),
    );
    try {
      http.Response response = await _sendData(
          address: "/checkpoint-histories/commit",
          body: jsonEncode([barcodeRecord]),
          token: token);
      if (response.statusCode == 200) {
        emit(MainPageStateInitial());
        emit(MainPageStateShowMessageDialog(
            message: strThisBarcodeDataSentSuccessfully));
      } else {
        emit(MainPageStateInitial());
        emit(MainPageStateShowMessageDialog(
            message: jsonDecode(response.body)["message"],
            messageColor: Colors.red));
      }
    } on Exception catch (e) {
      await Hive.box<BarcodeRecordModel>(BARCODE_BOX).add(barcodeRecord);
      emit(MainPageStateShowMessageDialog(
          message: strBarcodeAddedToLocalSuccessfully));
    }
  }

  void sendBarcodeDataForServer(String token) async {
    emit(MainPageStateLoading());

    List<BarcodeRecordModel> barcodeList =
        Hive.box<BarcodeRecordModel>(BARCODE_BOX).values.toList();

    print(barcodeList.length);

    try {
      http.Response response = await _sendData(
          address: "/checkpoint-histories/commit",
          body: jsonEncode(
              barcodeList.map((barcode) => barcode.toJson()).toList()),
          token: token);

      if (response.statusCode == 200) {
        Hive.box<BarcodeRecordModel>(BARCODE_BOX).clear();
        emit(MainPageStateInitial());
        emit(MainPageStateShowMessageDialog(
            message: strAllBarcodeSentSuccessfully));
      } else {
        emit(MainPageStateInitial());
        emit(MainPageStateShowMessageDialog(
            message: strSomethingWrong, messageColor: Colors.red));
      }
    } on Exception catch (e) {
      emit(MainPageStateInitial());
      emit(MainPageStateShowMessageDialog(
          message: strYouNeedInternetConnection, messageColor: Colors.red));
    }
  }

  void sendReportDataForServer(String token) async {
    emit(MainPageStateLoading());

    List<ReportModel> reportsList =
        Hive.box<ReportModel>(REPORT_BOX).values.toList();

    print(reportsList.length);

    try {
      http.Response response = await _sendData(
          address: "/competitor-histories/commit",
          body:
              jsonEncode(reportsList.map((report) => report.toJson()).toList()),
          token: token);

      if (response.statusCode == 200) {
        Hive.box<ReportModel>(REPORT_BOX).clear();
        emit(MainPageStateInitial());
        emit(MainPageStateShowMessageDialog(
            message: strAllReportsSentSuccessfully));
      } else {
        emit(MainPageStateInitial());
        emit(MainPageStateShowMessageDialog(
            message: strSomethingWrong, messageColor: Colors.red));
      }
    } on Exception catch (e) {
      emit(MainPageStateInitial());
      emit(MainPageStateShowMessageDialog(
          message: strYouNeedInternetConnection, messageColor: Colors.red));
    }
  }

  Future<http.Response> _sendData(
      {required String address,
      required String body,
      required String token}) async {
    var client = http.Client();
    Map<String, String> requestHeaders = {
      'Content-type': 'Application/json',
      "Authorization": token
    };
    http.Response response = await client.post(
        Uri(host: API_BASE_URL, path: address, port: 8090, scheme: "http"),
        headers: requestHeaders,
        body: body);
    print(response.statusCode);
    print(response.body);
    return response;
  }

  bool canLogOut() {
    if (Hive.box<BarcodeRecordModel>(BARCODE_BOX).values.length == 0 &&
        Hive.box<ReportModel>(REPORT_BOX).values.length == 0)
      return true;
    else {
      emit(MainPageStateShowMessageDialog(
          message: strFirstYouHaveToSendDataToServer,
          messageColor: Colors.red));
      return false;
    }
  }
}
