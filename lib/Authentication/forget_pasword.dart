
import 'package:e_c/DialogBox/errorDialog.dart';
import 'package:e_c/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forget extends StatefulWidget {
  @override
  _ForgetState createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final TextEditingController _emailController = TextEditingController();
  GlobalKey<FormState> _fontStale = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'images/login.png',
              height: 240.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Login to your account',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Form(
            key: _fontStale,
            child: Column(children: [
              CustomTextField(
                controller: _emailController,
                data: Icons.email,
                hintText: 'Email',
                isObsecure: false,
              ),
            ]),
          ),
         SizedBox(height: 20,),
         InkWell(
           onTap: (){
             _emailController.text.isNotEmpty?
             onpre(_emailController.text.trim()):
                 showDialog(context: context,
                 builder: (c){
                   return ErrorAlertDialog(
                     message: 'alala',
                   );
                 }
                 );
           },
           child: Container(
             alignment: Alignment.center,
             height: 50,
             width: 300,
             decoration: BoxDecoration(
               color: Colors.brown[500],
               borderRadius: BorderRadius.circular(10)
             ),
             child: Text('Forget',style: TextStyle(color: Colors.white,fontSize: 20,),),
           ),
         ),
        ]),
      ),
    );
  }
onpre( String email){
  showDialog(
      context: context,
      builder: (c) {
        return ErrorAlertDialog(
          message: 'A message has been sent to the email',
        );
      });
  FirebaseAuth auth= FirebaseAuth.instance;
  auth.sendPasswordResetEmail(email: email);
}
}
