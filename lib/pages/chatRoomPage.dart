import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kurakaani/main.dart';
import 'package:kurakaani/models/chat_room_model.dart';
import 'package:kurakaani/models/message_model.dart';
import 'package:kurakaani/models/user_model.dart';
import 'package:kurakaani/utils/color_utils.dart';
import 'package:kurakaani/widgets/custom_cached_image.dart';

class ChatRoomPage extends StatefulWidget {

  final UserModel targetUser;
  final ChatRoomModel chatRoomModel;
  final User? firebaseUser;

  ChatRoomPage({Key? key, required this.targetUser, required this.chatRoomModel,required this.firebaseUser}) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {

  TextEditingController _messageController=TextEditingController();

  void sendMessage() async{
    String msg=_messageController.text.trim();
    _messageController.text='';

    if(msg!=''){
      MessageModel messageModel=MessageModel(
        messageId: uuid.v1(),
        sender: widget.firebaseUser!.uid,
        createdOn: DateTime.now(),
        text: msg,
        seen: false
      );

      FirebaseFirestore.instance.collection('chatrooms').doc(widget.chatRoomModel.chatRoomId).collection('messages').doc(messageModel.messageId).set(messageModel.toMap());
      widget.chatRoomModel.lastMessage=msg;
      FirebaseFirestore.instance.collection("chatrooms").doc(widget.chatRoomModel.chatRoomId).set(widget.chatRoomModel.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
           SizedBox(
            height: 40,
            width: 40,
            child: CustomCachedImage.customCachedImage(userModel: widget.targetUser)),
            SizedBox(width: 10),
            Text(widget.targetUser.fullName.toString())
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Container(
                padding: EdgeInsets.symmetric(vertical:5,horizontal: 10),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/background.png')
                  )
                ),
                child:
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('chatrooms').doc(widget.chatRoomModel.chatRoomId).collection('messages').orderBy('createdon',descending: true).snapshots(),
                builder: (context,snapshot){
                  if(snapshot.connectionState==ConnectionState.active){
                    if(snapshot.hasData){
                      final dataSnapShot=snapshot.data;
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        reverse: true,
                          itemCount: dataSnapShot!.docs.length,
                          itemBuilder: (context,index){
                            MessageModel messageModel=MessageModel.fromMap(dataSnapShot.docs[index].data());
                        bool sender=messageModel.sender==widget.firebaseUser!.uid;
                          return Row(
                            mainAxisAlignment: (sender)?MainAxisAlignment.end:MainAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(
                                color:sender?ColorUtils.kButtonColor:Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  padding: EdgeInsets.all(15),
                                  child: Text('${messageModel.text}',style: TextStyle(color:sender?Colors.white:Colors.black),)),
                            ],
                          );
                      });
                    }
                    else{
                      return Text("An error occured");
                    }
                  }
                  else{
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              )
              )),
            Row(
              children: [
                Expanded(child:
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Enter message',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none
                    )
                  ),
                ),
                ),
                IconButton(onPressed: (){
                  sendMessage();
                }, icon: Icon(Icons.send))
              ],
            )
          ],
        ),
      ),
    );
  }
}
