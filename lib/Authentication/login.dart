import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_c/Admin/adminLogin.dart';
import 'package:e_c/Config/config.dart';
import 'package:e_c/DialogBox/errorDialog.dart';
import 'package:e_c/DialogBox/loadingDialog.dart';
import 'package:e_c/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Store/storehome.dart';
import '../main.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _fontStale = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
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
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailController,
                    data: Icons.email,
                    hintText: 'Email',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordController,
                    data: Icons.lock,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                setState(() {

                });
                _passwordController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty
                    ? userLogin()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog(
                            message: 'Please write email and password',
                          );
                        });
              setState(() {

              });
                },
              color: Colors.pink,
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.lightGreenAccent,
            ),
            SizedBox(height: 10.0),
            FlatButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => AdminSignInPage()));
              },
              icon: Icon(Icons.nature_people),
              label: Text(
                "i'm Admin",
                style:
                    TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void userLogin() async {
    FirebaseUser firebaseUser;
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Pless awaet for th',
          );
        });
    await _auth
        .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim())
        .then((userAuth) {
      firebaseUser = userAuth.user;
    }).catchError((error) {
      showDialog(
          context: context,
          builder: (context) {
            Navigator.pop(context);
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    print('ahmea1');
    if (firebaseUser != null) {
      print('ahmea2');
      readData(firebaseUser).then((value) {
        setState(() {

        });
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      });
    }
  }

  // ignore: missing_return
  Future readData(FirebaseUser fusre) async {
   Firestore.instance
        .collection('users')
        .document(fusre.uid)
        .get()
        .then((dataSnapShot) async {
      await EcommerceApp.sharedPreferences
          .setString('uid', dataSnapShot.data['uid']);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapShot.data['email']);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapShot.data['name']);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,
          dataSnapShot.data['url']);
      List<String> cartList =
          dataSnapShot.data['userCart'].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
    });
   setState(() {

   });

  }
}
