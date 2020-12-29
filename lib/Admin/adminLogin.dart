import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_c/Admin/uploadItems.dart';
import 'package:e_c/Authentication/authenication.dart';
import 'package:e_c/DialogBox/errorDialog.dart';
import 'package:e_c/Widgets/customTextField.dart';


import 'package:flutter/material.dart';


class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.lightGreenAccent,
                  Colors.pink,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text(
          'e-shop',
          style: TextStyle(
            color: Colors.white,
            fontSize: 55.0,
            fontFamily: 'Signatra',
          ),
        ),
        centerTitle: true,
      ),
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIdController = TextEditingController();
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
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.lightGreenAccent, Colors.pink],
                      begin: FractionalOffset(1.0, 0.0),
                      end: FractionalOffset(1.0, 1))),
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/admin.png',
                height: 240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Admin',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Form(
              key: _fontStale,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIdController,
                    data: Icons.person,
                    hintText: 'Id',
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
                _passwordController.text.isNotEmpty &&
                        _adminIdController.text.isNotEmpty
                    ? adminLogin()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog(
                            message: 'Please write email and password',
                          );
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
                    MaterialPageRoute(builder: (c) => AuthenticScreen()));
              },
              icon: Icon(Icons.nature_people),
              label: Text(
                "i'm not Admin",
                style:
                    TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  adminLogin() {
    Firestore.instance.collection('admin').getDocuments().then((snapShot) {
      snapShot.documents.forEach((element) {
        if (element.data['id'] != _adminIdController.text.trim()) {
          Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('your id is not correct')));
        } else if (element.data['password'] !=
            _passwordController.text.trim()) {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('your password is not correct')));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Welcome Dear Admin ' + element.data['name'])));
          setState(() {
            _passwordController.text = '';
            _adminIdController.text = '';
          });
          Route route = MaterialPageRoute(builder: (context) => UploadPage());
          Navigator.pushReplacement(context, route);
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Welcome Dear Admin ' + element.data['name'])));
        }
      });
    });
  }
}
