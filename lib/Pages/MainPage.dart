import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:racing_manager/Components/CustomDialog.dart';
import 'package:racing_manager/Components/MainButton.dart';
import 'package:racing_manager/Controllers/LoginPageController.dart';
import 'package:racing_manager/Controllers/MainPageController.dart';
import 'package:racing_manager/Resources/Strings.dart';
import 'package:restart_app/restart_app.dart';

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
                print("sdsd");
                if (context.read<MainPageController>().canLogOut()) {
                  print("2323");
                  await context.read<LoginPageController>().logOut();
                  print("after logout");
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
                    message: state.message, messageColor: state.messageColor));
          }
        },
        buildWhen: (oldState, newState) =>
            newState is! MainPageStateShowScanDialog &&
            newState is! MainPageStateShowMessageDialog,
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
