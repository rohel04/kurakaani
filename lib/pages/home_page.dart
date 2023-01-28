import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kurakaani/models/chat_room_model.dart';
import 'package:kurakaani/models/user_model.dart';
import 'package:kurakaani/pages/chatRoomPage.dart';
import 'package:kurakaani/utils/back_press_func.dart';
import 'package:kurakaani/utils/color_utils.dart';
import 'package:kurakaani/utils/constants.dart';
import 'package:kurakaani/widgets/custom_cached_image.dart';
import 'package:kurakaani/widgets/drawer.dart';
import 'package:kurakaani/widgets/shimmer_loading.dart';
import 'package:kurakaani/router.dart';
import '../bloc/authentication_bloc/authentication_bloc.dart';
import '../bloc/network_bloc/network_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firebaseUser = FirebaseAuth.instance.currentUser;
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        return BackPress.onBackPressed(context);
      },
      child: BlocListener<NetworkBloc, NetworkState>(
        listener: (context, state) {
          if (state is NetworkLossState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No internet connection')));
          }
          if (state is NetworkGainedState) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Connection established')));
          }
        },
        child: Scaffold(
          drawer: DrawerWidget(firestore: _fireStore, user: _firebaseUser,),
                    appBar: AppBar(
            title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Image.asset('assets/icons/appbar_icon.png',
                      height: 30, width: 30)),
              const SizedBox(width: 5),
              const Text(TextConstants.appBarTitle)
            ]),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.dark_mode))
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, Routers.searchScreen);
            },
            backgroundColor: ColorUtils.kButtonColor,
            child: const Icon(Icons.search),
          ),
          body: SafeArea(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .where("participants.${_firebaseUser!.uid}", isEqualTo: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  final chatRoomSnapshot = snapshot.data as QuerySnapshot;
                  if (chatRoomSnapshot.docs.length > 0) {
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: chatRoomSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                              chatRoomSnapshot.docs[index].data()
                                  as Map<String, dynamic>);
                          final participants = chatRoomModel.participants;
                          List<String> participantsKey =
                              participants!.keys.toList();
                          participantsKey.remove(_firebaseUser!.uid);
                          return FutureBuilder(
                              future: _fireStore
                                  .collection("users")
                                  .doc(participantsKey[0])
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  UserModel userModel = UserModel.fromMap(
                                      snapshot.data!.data()
                                          as Map<String, dynamic>);
                                  return ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatRoomPage(
                                                      targetUser: userModel,
                                                      chatRoomModel:
                                                          chatRoomModel,
                                                      firebaseUser:
                                                          _firebaseUser)));
                                    },
                                    leading: CustomCachedImage.customCachedImage(userModel: userModel),
                                    title: Text(
                                      userModel.fullName.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: chatRoomModel.lastMessage != ''
                                        ? Text('${chatRoomModel.lastMessage}')
                                        : Text(
                                            'Say hi to ${userModel.fullName}',
                                            style: TextStyle(
                                                color: Colors.blueAccent),
                                          ),
                                  );
                                } else {
                                  return Text("");
                                }
                              });
                        });
                  } else {
                    return Center(
                        child: Text(
                            'Start conversation by searching your friends'));
                  }
                } else {
                  return ShimmerLoading.shimmerLoading();
                }
              } else {
                return ShimmerLoading.shimmerLoading();
              }
            },
          )),
        ),
      ),
    );
  }
}
