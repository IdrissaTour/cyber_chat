import 'package:firebase_database/firebase_database.dart';
import 'myUser.dart';
import 'package:firebase_database/firebase_database.dart';

class Conversation{
  MyUser? user;
  String? date;
  String? msg;
  String? uid;

  Conversation(DataSnapshot snap){
    Map m = snap.value as Map<dynamic, dynamic>;
    user = MyUser(snap);
    date = m["dateString"];
    msg = m["lastMessage"];
    uid = m["monId"];


  }

}