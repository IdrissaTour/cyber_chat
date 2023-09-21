import 'package:cyber_chat/controller/dateHelper.dart';
import 'package:cyber_chat/model/customImage.dart';
import 'package:cyber_chat/model/firebaseHelper.dart';
import 'package:cyber_chat/model/message.dart';
import 'package:cyber_chat/model/myUser.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget{

  Message message;
  MyUser partenaire;
  Animation <double> animation;
  String? myId = FirebaseHelper().auth.currentUser!.uid;

  ChatBubble(this.message, this.partenaire, this.animation);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeIn),
      child: Container(
        margin: EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: bubble(myId == message.from),
        ),
      ),

    );
  }
  List<Widget> bubble ( bool moi){
    CrossAxisAlignment alignment = (moi)? CrossAxisAlignment.end:CrossAxisAlignment.start;
    Color color = (moi)? Colors.pink.shade200: Colors.indigo.shade200;
    return <Widget> [
      (moi)? Padding(padding: EdgeInsets.all(5)): CustomImage(imageUrl: partenaire.imageUrl ?? "", intiale: partenaire.initiales ??"", radius: 15),
      Expanded(
          child: Column(
            crossAxisAlignment: alignment,
            children: [
              Text(DateHelper().convert(message.dateString!) ?? ""),
              Card(
                elevation: 7,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: color,
                child: Container(
                  padding: EdgeInsets.all((message.imageUrl != null) ? 0 : 10),
                  child:
                  (message.imageUrl != null)
                  ? CustomImage(imageUrl: message.imageUrl!, intiale: "", radius: 0)
                  :Text(message.text ?? "" ),
                ),
              )
            ],
          )
      )
    ];
  }
}