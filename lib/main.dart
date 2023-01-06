import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kurakaani/pages/login_page.dart';
import 'package:kurakaani/pages/splash_screen.dart';
import 'package:kurakaani/router.dart';
import 'package:kurakaani/utils/color_utils.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings routeSettings)=>Routers.generateRoute(routeSettings),
      initialRoute: Routers.splashScreen,
      theme: ThemeData(
        fontFamily: 'OpenSans',
        appBarTheme:  AppBarTheme(
          backgroundColor: ColorUtils.kAppBarColor,
          elevation: 0.0
        ),
        buttonTheme: ButtonThemeData(buttonColor: ColorUtils.kButtonColor)
      ),
    );
  }
}
