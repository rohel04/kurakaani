import 'package:flutter/material.dart';
import 'package:kurakaani/pages/home_page.dart';
import 'package:kurakaani/utils/constants.dart';
import 'package:kurakaani/widgets/tween_image.dart';
import 'package:kurakaani/widgets/tween_text.dart';

import '../router.dart';
import '../utils/color_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customTimer();

  }

  void customTimer() async{
    await Future.delayed(const Duration(seconds: 6));
    Navigator.pushNamedAndRemoveUntil(context, Routers.wrapperScreen, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kButtonColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children:[ TweenImage(image: Image.asset('assets/icons/splash_icon.png',height: 80,width: 80),), TweenText(title: TextConstants.appBarTitle, fontSize: 20,fontWeight: FontWeight.bold,)
            ]),
      ),
    );
  }
}
