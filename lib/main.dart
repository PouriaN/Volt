import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:racing_manager/Controllers/MainPageController.dart';
import 'Controllers/LoginPageController.dart';
import 'Models/BarcodeRecordModel.dart';
import 'Models/EventModel.dart';
import 'Pages/LoginPage.dart';
import 'Pages/MainPage.dart';

bool isLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.registerAdapter<BarcodeRecordModel>(BarcodeRecordModelAdapter());
  Hive.registerAdapter<EventModel>(EventModelAdapter());
  await Hive.initFlutter();

  LoginPageController loginPageController = LoginPageController();
  isLoggedIn = await loginPageController.checkForLogin();

  runApp(Phoenix(
      child: MultiBlocProvider(providers: [
    BlocProvider<LoginPageController>.value(value: loginPageController),
    BlocProvider<MainPageController>(
        create: (context) => MainPageController(), lazy: false),
  ], child: MyApp())));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Racing Manager',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        accentColor: Colors.cyan,
      ),
      initialRoute: isLoggedIn ? "/MainPage" : "/LoginPage",
      routes: <String, WidgetBuilder>{
        '/LoginPage': (BuildContext context) => new LoginPage(),
        '/MainPage': (BuildContext context) => new MainPage(),
      },
    );
  }
}
