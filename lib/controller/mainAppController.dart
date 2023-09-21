import 'package:cyber_chat/controller/contactController.dart';
import 'package:cyber_chat/controller/messageController.dart';
import 'package:cyber_chat/controller/profileController.dart';
import 'package:cyber_chat/model/firebaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainController extends StatelessWidget {
  User? user = FirebaseHelper().auth.currentUser;
  List<Widget> contrllers(){
    return [
      MessageController(),
      ContactController(),
      ProfileController()
    ];
  }
  @override
  Widget build(BuildContext context) {
    final current = Theme.of(context).platform;
    if((current == TargetPlatform.iOS)){
      return CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            activeColor: Colors.black,
              inactiveColor: Colors.white,
              backgroundColor: Colors.indigo,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.message)),
                BottomNavigationBarItem(icon: Icon(Icons.supervisor_account)),
                BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
              ]
          ),
          tabBuilder: (BuildContext ctx, int index){
            Widget controleselect = contrllers()[index];
            return Scaffold(
              appBar: AppBar(title: Text("Cyber chat"),),
             body: controleselect
            );
          }
      );
    }else{
     return DefaultTabController(
         length:3, 
         child: Scaffold(
           appBar: AppBar(title: Text("Cyber chat"),
           bottom: TabBar(
               tabs: [
                 Tab(icon: Icon(Icons.message),),
                 Tab(icon: Icon(Icons.supervisor_account),),
                 Tab(icon: Icon(Icons.account_circle),),
               ]
           ),
           ),
           body: TabBarView(children: contrllers()) ,
         )
     );
    }

  }
}
