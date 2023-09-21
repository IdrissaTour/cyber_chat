import 'dart:io';

import 'package:cyber_chat/model/myUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper{
  // Authentification
  final auth = FirebaseAuth.instance;

  Future<User> handleSingIn(String adre, String mdp) async{
    final User user = (await auth.signInWithEmailAndPassword(email: adre, password: mdp)).user!;
    return user;
  }

  Future<bool> handleLogOut() async{
    await auth.signOut();
    return true;
  }

  Future<User> creation(String email, String motpass, String prenom, String nom) async{
    final creer = await auth.createUserWithEmailAndPassword(email: email, password: motpass);
    final user = creer.user;
    String uid = user!.uid;
    Map<String, String> map = {
      "prenom" : prenom,
       "nom" : nom,
      "uid" : uid
  };
    addUser(uid, map);
    return user;
  }



  // Database
  static final entry_point = FirebaseDatabase.instance.ref();
  final entry_users = entry_point.child("users");
  final entry_message = entry_point.child("messages");
  final entry_conv= entry_point.child("conversations");



  addUser(String uid, Map map){
    entry_users.child(uid).set(map);
  }

  // recuperation de l'utilisateur

  Future<MyUser> getUser(String uid) async {
    DataSnapshot snapshot = await entry_users.child(uid).once().then((event) => event.snapshot);
    MyUser user = MyUser(snapshot);
    return user;
  }

  senMessage(MyUser me, MyUser partenaire, String text, String imageUrl){
    // 1 id1 + id2
    String ref = getMessageRef(me.uid!, partenaire.uid!);
    String date = DateTime.now().millisecondsSinceEpoch.toString();
    Map map = {
      "from":me.uid,
      "to": partenaire.uid,
      "text":text,
      "dateString": date,
      "imageUrl ":imageUrl
    };
    entry_message.child(ref).child(date).set(map);

    // Notification de dernier message de conversation
    
    entry_conv.child(me.uid!).child(partenaire.uid!).set(setConversation(partenaire, me.uid!, text, date));
    entry_conv.child(partenaire.uid!).child(me.uid!).set(setConversation(me, me.uid!, text, date));


  }


  Map setConversation(MyUser user, String sender, String last, String dateString){
    // user, lastMessge, date
    Map map = user.toMap();
    map["monId"] = sender;
    map["lastMessage"] = last;
    map["dateString"]= dateString;

    return map;

  }

  getMessageRef(String from, String to){
    List<String> list = [from, to];
    list.sort((a,b) => a.compareTo(b));
    String ref = "";
    for(var x in list){
      ref += x + "+";
    }
    return ref;

  }


  // Storage

static final entrypoint = FirebaseStorage.instance.ref();
   final entryUser = entrypoint.child("users");
   final entryMessage = entrypoint.child("messages");


  Future<String> savePic(File file, Reference reference) async {
    try {
      UploadTask task = reference.putFile(file, SettableMetadata(contentType: 'image/jpeg'),);
      TaskSnapshot snap = await task.whenComplete(() => null);
      String url = await snap.ref.getDownloadURL();
      return url;
    } catch (e) {
      print("Erreur lors de l'enregistrement de l'image : $e");
      return "";
    }
  }











}