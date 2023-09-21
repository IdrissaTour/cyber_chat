import 'package:cyber_chat/controller/chatController.dart';
import 'package:cyber_chat/model/customImage.dart';
import 'package:cyber_chat/model/firebaseHelper.dart';
import 'package:cyber_chat/model/myUser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactController extends StatefulWidget {
  const ContactController({super.key});

  @override
  State<ContactController> createState() => _ContactControllerState();
}

class _ContactControllerState extends State<ContactController> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
        query: FirebaseHelper().entry_users,
        sort: (a, b) {
          final prenomA = (a.value as Map<String, dynamic>?)?["prenom"];
          final prenomB = (b.value as Map<String, dynamic>?)?["nom"];
          if (prenomA == null || prenomB == null) {
            return 0; // Vous pouvez choisir comment gérer les valeurs nulles ici
          }
          return prenomA.toString().toLowerCase().compareTo(prenomB.toString().toLowerCase());
        },



        itemBuilder: (BuildContext ctx, DataSnapshot snap , Animation<double> animation, int index){
          MyUser newUser = MyUser(snap);
          if(FirebaseHelper().auth.currentUser!.uid == newUser.uid){
             return Container();
          }else{
            return ListTile(
              leading: CustomImage(imageUrl: newUser!.imageUrl ?? '', intiale: newUser!.initiales ?? '', radius: 20),
              title: Text(newUser.fullNam()),
              trailing: IconButton(
                icon: Icon(Icons.message),
                onPressed: (){
                  Navigator.push(
                      context,
                     MaterialPageRoute(builder: (context){
                       return ChatController(newUser ,);
                     })
                  );
                },
              ),
            );
          }

        }
    );
  }
}
