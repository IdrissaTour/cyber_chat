import 'package:cyber_chat/controller/logController.dart';
import 'package:cyber_chat/controller/mainAppController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: _handleAuth(),
    );
  }

  Widget _handleAuth(){
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
        builder: (BuildContext ctx , snapshot){
          if(snapshot.hasData){
            return MainController();
          }else{
            return LogController();
          }
        }
    );
  }

}




