import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:volt/Models/BarcodeDataModel.dart';
import 'package:volt/Models/BarcodeRecordModel.dart';
import 'package:volt/Models/EventModel.dart';
import 'package:volt/Models/ReportModel.dart';
import 'package:volt/Resources/Constants.dart';
import 'package:volt/Resources/Strings.dart';

abstract class MainPageStates {}

class MainPageStateInitial extends MainPageStates {}

class MainPageStateLoading extends MainPageStates {}

class MainPageStateShowScanDialog extends MainPageStates {}

class MainPageStateShowMessageDialog extends MainPageStates {
  final List<String> messages;
  final Color? messageColor;

  MainPageStateShowMessageDialog({this.messageColor, required this.messages});
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
      actualTime: DateTime.now().toUtc().toIso8601String(),
      competitor: EventModel(id: barcode.competitorId),
      event: EventModel(id: barcode.eventId),
    );
    try {
      Response response = await _sendData(
          address: "/checkpoint-histories/commit",
          body: jsonEncode([barcodeRecord.toJson()]),
          token: token);
      if (response.statusCode == 200) {
        emit(MainPageStateInitial());
        emit(MainPageStateShowMessageDialog(
            messages: [strThisBarcodeDataSentSuccessfully]));
      } else {
        emit(MainPageStateInitial());
        emit(MainPageStateShowMessageDialog(
            messages: [jsonDecode(response.body)["message"]],
            messageColor: Colors.red));
      }
    } on Exception {
      await Hive.box<BarcodeRecordModel>(BARCODE_BOX)
          .put(barcodeRecord.actualTime, barcodeRecord);
      emit(MainPageStateShowMessageDialog(
          messages: [strBarcodeAddedToLocalSuccessfully]));
    }
  }

  void sendBarcodeDataForServer(String token) async {
    emit(MainPageStateLoading());
    List<BarcodeRecordModel> barcodeList =
        Hive.box<BarcodeRecordModel>(BARCODE_BOX).values.toList();

    print(barcodeList.length);

    if (barcodeList.length != 0) {
      List<String> responseList = <String>[];

      for (BarcodeRecordModel barcode in barcodeList) {
        try {
          Response response = await _sendData(
              address: "/checkpoint-histories/commit",
              body: jsonEncode([barcode.toJson()]),
              token: token);

          if (response.statusCode == 200)
            responseList.add("${barcode.competitor!.id}: $strSent");
          else {
            String message = jsonDecode(response.body)["message"];
            responseList.add("${barcode.competitor!.id}: $message");
          }
          await Hive.box<BarcodeRecordModel>(BARCODE_BOX)
              .delete(barcode.actualTime);
        } on Exception {
          responseList.add("${barcode.competitor!.id}: $strDoesNotSend");
        }
      }

      emit(MainPageStateShowMessageDialog(messages: responseList));
    } else {
      emit(MainPageStateShowMessageDialog(messages: [strThereIsNoDataToSend]));
    }
  }

  void sendReportDataForServer(String token) async {
    emit(MainPageStateLoading());

    List<ReportModel> reportsList =
        Hive.box<ReportModel>(REPORT_BOX).values.toList();

    print(reportsList.length);

    if (reportsList.length != 0) {
      List<String> responseList = [];

      for (ReportModel report in reportsList) {
        try {
          Response response = await _sendData(
              address: "/competitor-histories/commit",
              body: jsonEncode([report.toJson()]),
              token: token);

          if (response.statusCode == 200)
            responseList.add("${report.competitorNumber}: $strSent");
          else {
            String message = jsonDecode(response.body)["message"];
            responseList.add("${report.competitorNumber}: $message");
          }
          await Hive.box<ReportModel>(REPORT_BOX).delete(report.time);
        } on Exception {
          responseList.add("${report.competitorNumber}: $strDoesNotSend");
        }
      }

      emit(MainPageStateShowMessageDialog(
          messages:
              responseList.length == 0 ? [strDoesNotSend] : responseList));
    } else {
      emit(MainPageStateShowMessageDialog(messages: [strThereIsNoDataToSend]));
    }
  }

  Future<Response> _sendData(
      {required String address,
      required String body,
      required String token}) async {
    Client client = Client();
    Map<String, String> requestHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "$token"
    };
    Response response = await client.post(
        Uri(
            host: API_BASE_URL,
            path: address,
            port: SERVER_PORT,
            scheme: REQUEST_SCHEME),
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
          messages: [strFirstYouHaveToSendDataToServer],
          messageColor: Colors.red));
      return false;
    }
  }
}
