class MessageModel{
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdOn;

  MessageModel({this.sender,this.text,this.seen,this.createdOn});

  factory MessageModel.fromMap(Map<String,dynamic> map){
    return MessageModel(sender: map["sender"],text: map["text"],seen: map["seen"],createdOn:map["createdon"].toDate());
  }

  Map<String,dynamic> toMap(){
    return {
      "sender":sender,
      "text":text,
      "seem":seen,
      "createdon":createdOn
    };
  }
}