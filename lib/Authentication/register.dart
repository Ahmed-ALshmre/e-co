import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_c/Config/config.dart';
import 'package:e_c/DialogBox/errorDialog.dart';
import 'package:e_c/DialogBox/loadingDialog.dart';
import 'package:e_c/Widgets/customTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();
  GlobalKey<FormState> _fontStale = GlobalKey<FormState>();
  String userImageUrl = '';
  File _imageFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: () {
                selctAndPick();
                setState(() {});
              },
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : (FileImage(_imageFile)),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: _screenWidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              key: _fontStale,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    data: Icons.person,
                    hintText: 'Name',
                    isObsecure: false,
                  ),
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
                  CustomTextField(
                    controller: _cPasswordController,
                    data: Icons.lock,
                    hintText: 'Confirm',
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                uploadImage();
              },
              color: Colors.pink,
              child: Text(
                'Sign up',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.lightGreenAccent,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selctAndPick() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> uploadImage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlertDialog(
              message: 'Please select an image file',
            );
          });
    } else {
      _passwordController.text == _cPasswordController.text
          ? _nameController.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty &&
                  _emailController.text.isNotEmpty &&
                  _cPasswordController.text.isNotEmpty
              ? showD1el()
              : showDel('please file up the')
          : showDel('please ');
    }
  }

  Future<void> uploadTpStorig() async {
    return showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog();
        });
  }

  showDel(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  Future<void> showD1el() async {
    uploadTpStorig();
    String imageFileName = DateTime.now().microsecondsSinceEpoch.toString();
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot snapshot = await storageUploadTask.onComplete;
    await snapshot.ref.getDownloadURL().then((imageUrl) {
      userImageUrl = imageUrl;
      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim())
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      return showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.massage.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      saveUserInfoToFireStorage(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (context) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future<void> saveUserInfoToFireStorage(FirebaseUser fusre) async {
    Firestore.instance.collection('users').document(fusre.uid).setData({
      'uid': fusre.uid,
      'email': fusre.email,
      'name': _nameController.text,
      'url': userImageUrl,
      EcommerceApp.userCartList: ['garbageValue'],
    });
    await EcommerceApp.sharedPreferences.setString('uid', fusre.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fusre.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ['garbageValue']);
  }
}
