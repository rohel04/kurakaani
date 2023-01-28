
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kurakaani/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:kurakaani/models/user_model.dart';
import 'package:kurakaani/widgets/custom_cached_image.dart';


import '../main.dart';
import '../models/chat_room_model.dart';
import 'chatRoomPage.dart';

class SearchPage extends StatefulWidget {



  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController _searchController=TextEditingController();
  String user='';
  final firebaseUser=FirebaseAuth.instance.currentUser;

  Future<ChatRoomModel?> getChatRoom(UserModel targetUser) async{

    ChatRoomModel? chatRoomModel;

    final snapshot=await FirebaseFirestore.instance.collection('chatrooms').where("participants.${firebaseUser!.uid}",isEqualTo: true).where("participants.${targetUser.uid}",isEqualTo:true).get();
    if(snapshot.docs.length>0){
      var docData=snapshot.docs[0].data();
      ChatRoomModel existingChatRoom=ChatRoomModel.fromMap(docData);
      chatRoomModel=existingChatRoom;
      log('Alredy Created');
    }
    else{
      ChatRoomModel newChatRoom=ChatRoomModel(chatRoomId: uuid.v1(),lastMessage: "",participants: {
        firebaseUser!.uid.toString():true,
        targetUser.uid.toString():true
      });
      await FirebaseFirestore.instance.collection('chatrooms').doc(newChatRoom.chatRoomId).set(newChatRoom.toMap());
      chatRoomModel=newChatRoom;
      log("Created");
    }
    return chatRoomModel;
  }

  @override
  Widget build(BuildContext context) {
    final authentication=BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
        child: Column(
          children: [
            TextField(
              onChanged: (value){
                setState(() {
                  user=value+'@gmail.com';
                });
              },
              controller: _searchController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                label: Text('Search by email'),
                  suffixIcon: IconButton(onPressed: (){
                 setState(() {
                 });
                  },icon: Icon(Icons.search)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Colors.grey.shade400))
              ),

            ),
            const SizedBox(height: 30),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').where("email",isEqualTo:user).where('email',isNotEqualTo: FirebaseAuth.instance.currentUser!.email) .snapshots(),
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.active){
                    if(snapshot.hasData){
                      final dataSnapshot=snapshot.data;
                      if(dataSnapshot!.docs.length>0){
                        final usersMap=dataSnapshot.docs[0].data();
                        UserModel userModel=UserModel.fromMap(usersMap);
                        return ListTile(
                          onTap: () async{
                            ChatRoomModel? chatroomModel=await getChatRoom(userModel);

                            if(chatroomModel!=null){

                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>ChatRoomPage(targetUser: userModel, chatRoomModel: chatroomModel, firebaseUser: FirebaseAuth.instance.currentUser)));
                            }

                          },
                          trailing: Icon(Icons.keyboard_arrow_right),
                          leading: CustomCachedImage.customCachedImage(userModel:userModel),
                          title: Text(userModel.fullName!),
                          subtitle: Text(userModel.email!),
                        );
                      }
                      else{
                        return Text("No results Found !!");
                      }
                    }
                    else{
                      return Text("An error occurred !!");
                    }
                  }
                  else{
                    return SpinKitFadingCircle(color: Colors.black87,size: 30,);
                  }
            })
          ],
        ),
      ),
    );
  }
}
