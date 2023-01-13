import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kurakaani/pages/home_page.dart';
import 'package:kurakaani/pages/login_page.dart';

import '../bloc/authentication_bloc.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {


  @override
  Widget build(BuildContext context) {
  final p=BlocProvider.of<AuthenticationBloc>(context);
    return StreamBuilder(
        stream: p.user,
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.active){
            final user=snapshot.data;
            return user!=null?HomePage():LoginPage();
          }
          else{
            return SpinKitFadingCircle(color: Colors.black);
          }
    });
  }
}
