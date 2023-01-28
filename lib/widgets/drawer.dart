import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kurakaani/models/user_model.dart';
import 'package:kurakaani/widgets/custom_cached_image.dart';

import '../bloc/authentication_bloc/authentication_bloc.dart';
import '../router.dart';
import '../utils/color_utils.dart';

class DrawerWidget extends StatefulWidget {

  final FirebaseFirestore firestore;
  final User? user;

  const DrawerWidget({super.key,required this.firestore,required this.user});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
        final authentication = BlocProvider.of<AuthenticationBloc>(context);
    return Drawer(
            backgroundColor: ColorUtils.kButtonColor,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder(
                      future: widget.firestore.collection('users').doc(widget.user!.uid).get(),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          UserModel userModel=UserModel.fromMap(snapshot.data!.data() as Map<String,dynamic>);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomCachedImage.customCachedImage(userModel: userModel),
                              SizedBox(height: 10),
                              Text('${userModel.fullName}',style: TextStyle(color: Colors.white,fontSize: 18),),
                              Text('${userModel.email}',style: TextStyle(color: Colors.white,fontSize: 14),),
                                                  Divider(height: 40,color: Colors.white,),

                            ],
                          );
                        }
                        else{
                          return Text('Loading..');
                        }
                    }),
                    InkWell(
                      onTap: () async {
                        await authentication.signOut();
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routers.wrapperScreen, (route) => false);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_sharp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Sign Out',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}