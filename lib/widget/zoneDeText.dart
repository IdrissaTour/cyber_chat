import 'dart:io';

import 'package:cyber_chat/model/firebaseHelper.dart';
import 'package:cyber_chat/model/myUser.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ZoneDeText extends StatefulWidget{
  MyUser partenaire;
  MyUser me;

  ZoneDeText(this.partenaire, this.me);

      @override
  ZoneTextState createState() => ZoneTextState();
}
class ZoneTextState extends State<ZoneDeText>{
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      padding: EdgeInsets.all(3.5),
      child: Row(
        children: [
          IconButton(onPressed: () => takePic(ImageSource.camera), icon:Icon(Icons.camera_enhance)),
          IconButton(onPressed: () => takePic(ImageSource.gallery), icon:Icon(Icons.photo_library)),
          Flexible(child: TextField(
            controller: _controller,
            decoration: InputDecoration.collapsed(hintText: "Ecrivez quelque chose",),
            maxLines: null,
          )),
          IconButton(onPressed:sendMessageButton, icon:Icon(Icons.send)),
        ],
      ),
    );

  }

  sendMessageButton() {
    print("message envoyé");
    if (widget.me != null && widget.partenaire != null) {
      if (_controller.text != null && _controller.text.isNotEmpty) {
        String text = _controller.text;
        // 1 Envoyer vers Firebase
        FirebaseHelper().senMessage(widget.me!, widget.partenaire!, text, "");
        // Supprimer le contenu du champ
        _controller.clear();
        // Fermer
        FocusScope.of(context).requestFocus(FocusNode());
      } else {
        print("text vide");
      }
    } else {
      print("widget.me ou widget.partenaire est null");
    }
  }

  Future<void> takePic(ImageSource source) async {
    XFile? picked = await ImagePicker().pickImage(source: source, maxHeight: 2000, maxWidth:2000,);
    if (picked != null) {
      File file = File(picked.path);
      String date = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference = FirebaseHelper().entryMessage.child(widget.me.uid!).child(date);
      FirebaseHelper().savePic(file, reference).then((imageUrl) {
        FirebaseHelper().senMessage(widget.me,widget.partenaire, "", imageUrl);
        print(" image envoye");
      });

    }
  }



}