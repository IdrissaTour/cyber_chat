
import 'package:cyber_chat/model/firebaseHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogController extends StatefulWidget {
  const LogController({super.key});

  @override
  State<LogController> createState() => _LogControllerState();
}

class _LogControllerState extends State<LogController> {
  String? _email;
  String? _mdp;
  String? _prenom;
  String? _nom;


  bool log = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(log?"Login" :"Sing up" ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.all(10),

              height:size.height*0.25 ,
              width: size.width*0.85,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Cy", style:  TextStyle(fontSize: 100, fontWeight: FontWeight.bold),),
                  SizedBox(width: 10,),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("bert", style:  TextStyle(fontSize: 70, color: Colors.purple)),
                        Text("chat",style:  TextStyle(fontSize: 30,fontWeight: FontWeight.bold ))

                      ],
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: textfields(),
            ),
           Padding(padding: EdgeInsets.all(20)),
            ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll(Size(200,50))
              ),
                onPressed: handle,
                child: Text(log?"Login" : "Sing up", style: TextStyle(fontSize: 30),)
            ),
            TextButton(onPressed:(){
              setState(() {
                log = !log;
              });
            } ,
                child: Text(log? "Inscrivez-vous!":"Connectez-vous !", style: TextStyle(fontSize: 18, color: Colors.purple))
            )

          ],
        ),
      ),
    );
  }
  handle(){
    if(_email != null){
      if(_mdp != null){
       if(log){
         FirebaseHelper().handleSingIn(_email!, _mdp!).then((user){
           print(user.uid);
         }).catchError((errore){
           alert(errore.toString());
         });
       }else{
         if(_prenom != null){
           if(_nom != null){
             FirebaseHelper().creation(_email!, _mdp!, _prenom!, _nom!).then((user){
               print(user.uid);
             }).catchError((error){
               alert(error.toString());
             });
           }else{
             alert("champ nom non renseigner");
           }
         }else{
           alert("champ penom non renseigner");
         }
       }
      }else{
        alert("Mot de passe non renseigner");
      }
    }else{
      alert("Adresse email non renseigner");
    }
  }

  List<Widget> textfields(){
    List<Widget> widgets = [];
    widgets.add(TextField(
      decoration: InputDecoration(
          hintText: "Adresse mail",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0))
      ),
      onChanged: (string){
        setState(() {
          _email= string;
        });
      },
    ));
    widgets.add(SizedBox(height: 10,));
    widgets.add(TextField(
      decoration: InputDecoration(
          hintText: "Mot de passe ",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0))
      ),
      onChanged: (string){
        setState(() {
          _mdp= string;
        });
      },
    ));
    if(!log){
      widgets.add(SizedBox(height: 10,));
      widgets.add(TextField(
        decoration: InputDecoration(
            hintText: "Prénom",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0)
            )
        ),
        onChanged: (string){
          setState(() {
            _prenom= string;
          });
        },
      ));
      widgets.add(SizedBox(height: 10,));
      widgets.add(TextField(
        decoration: InputDecoration(
            hintText: "Nom",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0))

        ),
        onChanged: (string){
          setState(() {
            _nom= string;
          });
        },
      ));
    }


    return widgets;
  }


  Future<void> alert(String message) async{
   Text title = Text("erreur");
   Text msg = Text(message);
   TextButton okButton = TextButton(onPressed:()=>Navigator.pop(context),
       child: Text("OK")
   );
   return showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext ctx){
         return (Theme.of(context).platform == TargetPlatform.iOS)
             ? CupertinoAlertDialog(content: msg,title: title,actions: [okButton],)
             : AlertDialog(content: msg,title: title,actions: [okButton]);
       }
   );

}


}
