import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:restart_app/restart_app.dart';
import 'package:volt/Components/CustomDialog.dart';
import 'package:volt/Components/MainButton.dart';
import 'package:volt/Controllers/LoginPageController.dart';
import 'package:volt/Controllers/MainPageController.dart';
import 'package:volt/Resources/Strings.dart';

class MainPage extends StatelessWidget {
  Dialog scanDialog(BuildContext context) => Dialog(
        child: FractionallySizedBox(
          heightFactor: 0.4,
          child: Stack(
            alignment: Alignment.center,
            children: [
              QRView(
                key: GlobalKey(debugLabel: 'QR'),
                onQRViewCreated: (QRViewController controller) {
                  controller.scannedDataStream.listen((scanData) {
                    print(scanData);
                    controller.pauseCamera();
                    controller.dispose();
                    Navigator.pop(context);
                    context.read<MainPageController>().gotNewScan(
                        scanData.code,
                        context
                            .read<LoginPageController>()
                            .loginResponseModel
                            .userId!,
                        context
                            .read<LoginPageController>()
                            .loginResponseModel
                            .authorization!);
                  });
                },
              ),
              FractionallySizedBox(
                heightFactor: 0.75,
                widthFactor: 0.75,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 5)),
                ),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Racing Manager"),
        actions: [
          IconButton(
              onPressed: () async {
                if (context.read<MainPageController>().canLogOut()) {
                  await context.read<LoginPageController>().logOut();
                  Restart.restartApp();
                }
              },
              icon: Icon(Icons.login_rounded))
        ],
      ),
      body: BlocConsumer<MainPageController, MainPageStates>(
        listener: (context, state) {
          if (state is MainPageStateShowScanDialog) {
            showDialog(
                context: context, builder: (context) => scanDialog(context));
          } else if (state is MainPageStateShowMessageDialog) {
            showDialog(
                context: context,
                builder: (context) => CustomDialog(
                    messages: state.messages,
                    messageColor: state.messageColor));
          }
        },
        buildWhen: (oldState, newState) =>
            newState is! MainPageStateShowScanDialog,
        builder: (context, state) => Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MainButton(
                      text: strScanParticipant,
                      enable: state is! MainPageStateLoading,
                      callBack: () =>
                          context.read<MainPageController>().showScanDialog()),
                  MainButton(
                      text: strSendScanToServer,
                      enable: state is! MainPageStateLoading,
                      color: Colors.redAccent,
                      callBack: () => context
                          .read<MainPageController>()
                          .sendBarcodeDataForServer(context
                              .read<LoginPageController>()
                              .loginResponseModel
                              .authorization!)),
                  //   callBack: () {
                  //     context
                  //         .read<MainPageController>()
                  //         .emit(MainPageStateShowMessageDialog(messages: [
                  //           "233: ارسال شده",
                  //           "233: ارسال شده",
                  //           "233: ارسال شده",
                  //           "233: ارسال شده",
                  //           "233: ارسال شده",
                  //         ]));
                  //   },
                  // ),
                  Divider(color: Colors.white, thickness: 1),
                  MainButton(
                      text: strCreateReport,
                      enable: state is! MainPageStateLoading,
                      callBack: () =>
                          Navigator.pushNamed(context, "/ReportPage")),
                  MainButton(
                      text: strSendReportsToServer,
                      enable: state is! MainPageStateLoading,
                      color: Colors.redAccent,
                      callBack: () => context
                          .read<MainPageController>()
                          .sendReportDataForServer(context
                              .read<LoginPageController>()
                              .loginResponseModel
                              .authorization!)),
                ],
              ),
            ),
            state is MainPageStateLoading
                ? ModalBarrier(
                    dismissible: false,
                    color: Colors.grey.withOpacity(0.5),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
