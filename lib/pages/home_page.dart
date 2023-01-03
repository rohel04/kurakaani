import 'package:flutter/material.dart';
import 'package:kurakaani/utils/color_utils.dart';
import 'package:kurakaani/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            margin: const EdgeInsets.fromLTRB(5, 5, 0, 5),
            child: Image.asset('assets/icons/splash_icon.png')),
        title: const Text(TextConstants.appBarTitle),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {  },
        backgroundColor: ColorUtils.kButtonColor,
      child:const Icon(Icons.message),
      ),
      body: SafeArea(
        child: Container(
          color: ColorUtils.kBackgroundColor,
          child:  const Center(
            child:Text('Kurakaani',style: TextStyle(fontSize: 20),) ,
          ),
        ),
      ),
    );
  }
}
