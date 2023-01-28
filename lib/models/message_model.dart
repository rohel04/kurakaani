class MessageModel{
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdOn;

  MessageModel({this.sender,this.text,this.seen,this.createdOn,this.messageId});

  factory MessageModel.fromMap(Map<String,dynamic> map){
    return MessageModel(sender: map["sender"],text: map["text"],seen: map["seen"],createdOn:map["createdon"].toDate(),messageId: map['messageid']);
  }

  Map<String,dynamic> toMap(){
    return {
      "sender":sender,
      "text":text,
      "seem":seen,
      "createdon":createdOn,
      "messageid":messageId
    };
  }
}