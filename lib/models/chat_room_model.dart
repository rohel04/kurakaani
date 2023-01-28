class ChatRoomModel{
  String? chatRoomId;
  Map<String,dynamic>? participants;
  String? lastMessage;

  ChatRoomModel({this.chatRoomId,this.participants,this.lastMessage});

  factory ChatRoomModel.fromMap(Map<String,dynamic> map){
    return ChatRoomModel(chatRoomId:map["chatroomid"],participants: map['participants'],lastMessage: map["lastmessage"]);
  }

  Map<String,dynamic> toMap(){
    return {
      "chatroomid":chatRoomId,
      "participants":participants,
      "lastmessage":lastMessage
    };
  }

}