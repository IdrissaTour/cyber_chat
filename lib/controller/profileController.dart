
import 'dart:io';

import 'package:cyber_chat/model/customImage.dart';
import 'package:cyber_chat/model/firebaseHelper.dart';
import 'package:cyber_chat/model/myUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ProfileController extends StatefulWidget {
  const ProfileController({super.key});

  @override
  State<ProfileController> createState() => _ProfileControllerState();
}

class _ProfileControllerState extends State<ProfileController> {
  MyUser? me;
  String? prenom;
  String? nom;

  User? user = FirebaseHelper().auth.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _getUser();
  }
  @override
  Widget build(BuildContext context) {
    return (me == null)
        ? Center(child: Text("Chargement...."),)
        : SingleChildScrollView(
      child: Container(
        margin:  EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
      CustomImage(imageUrl: me!.imageUrl ?? '', intiale: me!.initiales ?? '', radius: MediaQuery.of(context).size.width/5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () => _takAPic(ImageSource.camera),
                        icon: Icon(Icons.camera_enhance)
                    ),
                    IconButton(
                        onPressed: () => _takAPic(ImageSource.gallery),
                        icon: Icon(Icons.photo_library)
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.all(5)),
                TextField(
                  decoration: InputDecoration(
                    hintText:me!.prenom,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.5)
                      )
                  ),
                  onChanged: (str){
                    setState(() {
                      prenom = str;
                    });
                  },
                ),
            SizedBox(height: 10,),
            TextField(
              decoration: InputDecoration(
                  hintText: me!.nom,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.5)
                  )
              ),
              onChanged: (str){
                setState(() {
                  nom = str;
                });
              },
            ),
            Padding(padding: EdgeInsets.all(5)),
            ElevatedButton(
                onPressed: saveChanges,
                child: Text("Sauvegarder")
            ),
            TextButton(
                onPressed: logout,
                child: Text("Se déconnecter")
            )

          ],
      )
      ),
    );

  }

  Future<void> logout() async{
    Text title = Text("Deconnexion");
    Text content = Text("Etes vous sûr de voulir vous déconnecter?");
    ElevatedButton NonButton = ElevatedButton(
        onPressed: (){
          Navigator.of(context).pop();
        }, child: Text("Non"));
    ElevatedButton OkButton = ElevatedButton(
        onPressed: (){
          FirebaseHelper().handleLogOut().then((bool) {
            Navigator.of(context).pop();
          });
        }, child: Text("Oui"));
    return showDialog(context: context, builder: (BuildContext ctx){
      return (Theme.of(context).platform == TargetPlatform.iOS)
      ? CupertinoAlertDialog(title: title,content: content,actions: [OkButton, NonButton],)
          : AlertDialog(title: title, content: content, actions: [OkButton, NonButton],);
    });

  }

  saveChanges(){
    Map map = me!.toMap();
    if(prenom != null && prenom != "") {
      map["prenom"] = prenom;
    }
    if(nom != null && nom != ""){
        map["nom"] = nom;
      }
    FirebaseHelper().addUser(me!.uid!, map);

  }
  _getUser(){
    FirebaseHelper().getUser(user!.uid).then((me){
      setState(() {
        this.me = me;
      });
    });
  }

  Future<void> _takAPic(ImageSource source)async{
    XFile? img = await ImagePicker().pickImage(source: source, maxWidth: 500, maxHeight: 500 );
    if(img != null){
      File file = File(img.path);
      FirebaseHelper().savePic(file, FirebaseHelper().entryUser.child(me!.uid!)).then((str){
        // add User
        Map map = me!.toMap();
       map["imageUrl"] = str;
       FirebaseHelper().addUser(me!.uid!, map);
       _getUser();
      });
    }
  }

}
