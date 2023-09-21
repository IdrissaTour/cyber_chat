import 'package:cyber_chat/controller/chatController.dart';
import 'package:cyber_chat/controller/dateHelper.dart';
import 'package:cyber_chat/model/conversation.dart';
import 'package:cyber_chat/model/customImage.dart';
import 'package:cyber_chat/model/firebaseHelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageController extends StatefulWidget {
  const MessageController({super.key});

  @override
  State<MessageController> createState() => _MessageControllerState();
}

class _MessageControllerState extends State<MessageController> {

  String? uid = FirebaseHelper().auth.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
        query: FirebaseHelper().entry_conv.child(uid!),

        itemBuilder: (BuildContext ctx, DataSnapshot snapshot, Animation<double> anim, int index){
          Conversation conversation = Conversation(snapshot);
        String sub = (conversation.uid == uid) ? " Moi:" : "";
          sub += (" ${conversation.msg}" );

          return ListTile(
           leading:CustomImage(imageUrl: conversation.user!.imageUrl ?? "" , intiale: conversation.user!.initiales ?? "" , radius: 20) ,
            title:Text(conversation.user!.fullNam()) ,
            subtitle: Text(sub),
          trailing: Text(DateHelper().convert(conversation.date!) ?? ""),
              onTap: () {
                if (conversation.user != null) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext ctx) {
                    return ChatController(conversation.user!,);
                  }));
                } else {
                  // Gérer le cas où conversation.user est nul, par exemple en affichant un message d'erreur.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Erreur"),
                        content: Text("L'utilisateur est nul."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              }


          );
        }
    );

  }
}
