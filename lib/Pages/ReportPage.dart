import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:volt/Components/CustomDialog.dart';
import 'package:volt/Components/CustomTextFiled.dart';
import 'package:volt/Components/MainButton.dart';
import 'package:volt/Controllers/LoginPageController.dart';
import 'package:volt/Models/ReportModel.dart';
import 'package:volt/Resources/Constants.dart';
import 'package:volt/Resources/Strings.dart';

enum ReportType {
  PASS_CONTROL,
  ENTER_IN_GATE_FROM_WRONG_PATH,
  NOT_FASTEN_SEAT_BELT,
  STOP_IN_MARSHAL_RANGE_VIEW,
  REVERSE_GEAR,
  DANGEROUS_MOVEMENT,
  TURN_IN_CONTROL_AREA,
}

class ReportPage extends StatelessWidget {
  final TextEditingController competitorController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final List<DropdownMenuItem<ReportType>> typeDropDownItems = [
    DropdownMenuItem(
        value: ReportType.PASS_CONTROL, child: Text(strPassControl)),
    DropdownMenuItem(
        value: ReportType.ENTER_IN_GATE_FROM_WRONG_PATH,
        child: Text(strEnterInGateFromWrongPath)),
    DropdownMenuItem(
        value: ReportType.NOT_FASTEN_SEAT_BELT,
        child: Text(strNotFastenSeatBelt)),
    DropdownMenuItem(
        value: ReportType.STOP_IN_MARSHAL_RANGE_VIEW,
        child: Text(strStopInMarshalRangeView)),
    DropdownMenuItem(
        value: ReportType.REVERSE_GEAR, child: Text(strReverseGear)),
    DropdownMenuItem(
        value: ReportType.DANGEROUS_MOVEMENT,
        child: Text(strDangerousMovement)),
    DropdownMenuItem(
        value: ReportType.TURN_IN_CONTROL_AREA,
        child: Text(strTurnInControlArea)),
  ];
  ReportType? selectedReportType;

  Future<http.Response> _sendData(
      {required String address,
      required String body,
      required String token}) async {
    var client = http.Client();
    Map<String, String> requestHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "$token"
    };
    http.Response response = await client.post(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(strCreateReport)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Form(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            CustomTextField(
                inputType: TextInputType.number,
                prefixIcon: Icons.account_box_outlined,
                controller: competitorController,
                label: strCompetitorNumber),
            SizedBox(height: 15),
            CustomTextField(
                expand: true,
                prefixIcon: Icons.description_outlined,
                inputType: TextInputType.multiline,
                controller: descController,
                label: strDescription),
            SizedBox(height: 15),
            DropdownButtonFormField<ReportType>(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30))),
                onChanged: (reportType) => selectedReportType = reportType!,
                hint: Text(strSelectReportType),
                items: typeDropDownItems),
            SizedBox(height: 30),
            MainButton(
                text: strAddReport,
                callBack: () async {
                  if (competitorController.text.isNotEmpty &&
                      selectedReportType != null) {
                    ReportModel report = ReportModel(
                        competitorNumber: int.parse(competitorController.text),
                        description: descController.text,
                        type: selectedReportType.toString().split(".")[1],
                        time: DateTime.now().toUtc().toIso8601String());

                    try {
                      http.Response response = await _sendData(
                          address: "/competitor-histories/commit",
                          body: jsonEncode([report.toJson()]),
                          token: context
                              .read<LoginPageController>()
                              .loginResponseModel
                              .authorization!);

                      if (response.statusCode == 200) {
                        await showDialog(
                          context: context,
                          builder: (ctx) => CustomDialog(messages: [
                            strThisReportSentToServerSuccessfully
                          ]),
                        );
                        Navigator.pop(context);
                      } else {
                        await showDialog(
                          context: context,
                          builder: (ctx) => CustomDialog(
                              messages: [jsonDecode(response.body)["message"]],
                              messageColor: Colors.red),
                        );
                      }
                    } on Exception catch (e) {
                      await Hive.box<ReportModel>(REPORT_BOX)
                          .put(report.time, report);
                      await showDialog(
                        context: context,
                        builder: (ctx) => CustomDialog(
                            messages: [strReportAddedToLocalSuccessfully]),
                      );
                      Navigator.pop(context);
                    }
                  } else {
                    await showDialog(
                      context: context,
                      builder: (ctx) => CustomDialog(
                          messages: [strFirstEnterValues],
                          messageColor: Colors.red),
                    );
                  }
                }),
          ],
        )),
      ),
    );
  }
}
