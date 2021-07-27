import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:racing_manager/Components/CustomTextFiled.dart';
import 'package:racing_manager/Components/MainButton.dart';
import 'package:racing_manager/Controllers/LoginPageController.dart';
import 'package:racing_manager/Resources/Strings.dart';
import 'package:racing_manager/Resources/TextThemes.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController(),
      passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginPageController, LoginPageStates>(
        listener: (context, state) {
          if (state is LoginPageStateGetLoggedIn)
            Navigator.pushReplacementNamed(context, "/MainPage");
        },
        buildWhen: (oldState, newState) =>
        newState is! LoginPageStateGetLoggedIn,
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
                body: Column(
                  children: [
                    Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Container(
                          color: Colors.blue,
                          alignment: Alignment.center,
                          child: Text(strLogin, style: textThemeLogin),
                        )),
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextField(
                                  label: strUsername,
                                  controller: usernameController,
                                  prefixIcon: Icons.account_circle_rounded,),
                                SizedBox(height: 10),
                                CustomTextField(
                                    label: strPassword,
                                    isObscure: true,
                                    controller: passwordController,
                                    prefixIcon: Icons.password),
                                SizedBox(height: 15),
                                MainButton(
                                    text: strLogin,
                                    enable: state is! LoginPageStateLoading,
                                    callBack: () {
                                      if (usernameController.text.isNotEmpty &&
                                          passwordController.text
                                              .isNotEmpty) context
                                          .read<LoginPageController>()
                                          .setLoginDetails(
                                          usernameController.text,
                                          passwordController.text);
                                    })
                              ],
                            ),
                          ),
                          state is LoginPageStateLoading
                              ? ModalBarrier(
                            dismissible: false,
                            color: Colors.grey.withOpacity(0.5),
                          )
                              : Container(),
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
  }
}
