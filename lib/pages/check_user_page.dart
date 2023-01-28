import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kurakaani/router.dart';
import 'package:kurakaani/utils/color_utils.dart';

class CheckUserPage extends StatefulWidget {
  const CheckUserPage({Key? key}) : super(key: key);

  @override
  State<CheckUserPage> createState() => _CheckUserPageState();
}

class _CheckUserPageState extends State<CheckUserPage> {

  final _fireStore=FirebaseFirestore.instance;
  final _firestoreAuth=FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkParam();

  }

  checkParam() async{
    final data=await _fireStore.collection("users").doc(_firestoreAuth.currentUser!.uid).get();
    final a=data.data();
    if(a!["fullname"]==''){
      Navigator.pushNamedAndRemoveUntil(context, Routers.completeProfileScreen, (route) => false);
    }
    else{
      Navigator.pushNamedAndRemoveUntil(context, Routers.homeScreen, (route) => false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorUtils.kButtonColor,
        child: SpinKitFadingCircle(
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
