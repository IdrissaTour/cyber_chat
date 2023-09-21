
import 'package:cyber_chat/model/customImage.dart';
import 'package:cyber_chat/model/firebaseHelper.dart';
import 'package:cyber_chat/model/message.dart';
import 'package:cyber_chat/model/myUser.dart';
import 'package:cyber_chat/widget/chatBubble.dart';
import 'package:cyber_chat/widget/zoneDeText.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ChatController extends StatefulWidget{
  // il va nous servier à qui on dialogue

  MyUser partenaire;

  ChatController(this.partenaire, );
   @override
  ChatControllerState createState() => ChatControllerState();
}
class ChatControllerState extends State<ChatController>{
   MyUser? me;

  @override
  void initState() {
    // TODO: implement initState
    String? uid = FirebaseHelper().auth.currentUser?.uid;
    ;
    FirebaseHelper().getUser(uid!).then((user) {
     setState(() {
       this.me = user;
     });
    });
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomImage(imageUrl: widget.partenaire.imageUrl ?? "", intiale: widget.partenaire.initiales ?? '', radius: 15),
        Text(widget.partenaire.fullNam())
      ],
    ),),
    body: InkWell(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Column(
        children: [
          Flexible(
              child:(me != null)
              ?FirebaseAnimatedList(
                  query: FirebaseHelper().entry_message.child(FirebaseHelper().getMessageRef(me!.uid!, widget.partenaire.uid!)),
                  sort: (a,b) => b.key!.compareTo(a.key!),
                  reverse: true,
                  itemBuilder: (BuildContext ctx, DataSnapshot snap, Animation<double> animation, int index){
                    Message msg = Message(snap);
                    return ChatBubble(msg, widget.partenaire, animation);
                  }
              )
                  : Center(child: Text("Chargeent..."),)
          ),
          Divider(height: 2,),


            ZoneDeText(widget.partenaire, me!)


        ],
      ),
    ),
  );
  }
}