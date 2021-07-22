import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:racing_manager/Components/MainButton.dart';
import 'package:racing_manager/Controllers/LoginPageController.dart';
import 'package:racing_manager/Controllers/MainPageController.dart';
import 'package:racing_manager/Resources/Strings.dart';

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
                            .userId!);
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
                await context.read<LoginPageController>().logOut();
                Phoenix.rebirth(context);
              },
              icon: Icon(Icons.login_rounded))
        ],
      ),
      body: BlocConsumer<MainPageController, MainPageStates>(
        listener: (context, state) {
          if (state is MainPageStateShowDialog) {
            showDialog(
                context: context, builder: (context) => scanDialog(context));
          } else if (state is MainPageStateShowSnack) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        buildWhen: (oldState, newState) =>
            newState is! MainPageStateShowDialog &&
            newState is! MainPageStateShowSnack,
        builder: (context, state) => Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MainButton(
                      text: strScan,
                      callBack: () =>
                          context.read<MainPageController>().showScanDialog()),
                  MainButton(
                      text: strSendToServer,
                      enable: state is! MainPageStateLoading,
                      color: Colors.redAccent,
                      callBack: () => context
                          .read<MainPageController>()
                          .sendDataForServer(context
                              .read<LoginPageController>()
                              .loginResponseModel
                              .authorization!))
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
