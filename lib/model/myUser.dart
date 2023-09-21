import 'package:firebase_database/firebase_database.dart';

class MyUser{
  String? uid;
  String? prenom;
  String? nom;
  String? imageUrl;
  String? initiales;

  MyUser(DataSnapshot snapshot) {
    uid = snapshot.key;
    Map map = snapshot.value as Map;

    if (map != null) {
      prenom = map["prenom"] ;
      nom = map["nom"] ;
      imageUrl = map["imageUrl"] ;
      if (prenom != null && prenom!.isNotEmpty) {
        initiales = prenom![0];
      }
      if (nom != null && nom!.isNotEmpty) {
        if (initiales != null) {
          initiales = initiales! + nom![0];
        } else {
          initiales = nom![0];
        }
      }
    }
  }


  // pour convertir et envoyer au firebase
  Map toMap(){
    return {
      "prenom":prenom,
      "nom": nom,
      "imageUrl": imageUrl,
      "uid": uid
    };
  }
  String fullNam(){
    return "$prenom $nom";
  }
}