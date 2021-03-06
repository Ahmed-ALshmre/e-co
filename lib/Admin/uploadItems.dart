import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_c/Widgets/loadingWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as ImD;
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import 'adminShiftOrders.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  TextEditingController _decTextEditingController = TextEditingController();
  TextEditingController _priTextEditingController = TextEditingController();
  TextEditingController _titelTextEditingController = TextEditingController();
  TextEditingController _showextEditingController = TextEditingController();
  String productId = DateTime.now().microsecondsSinceEpoch.toString();
  File file;
  bool upLoding = false;
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAAdmin() : displayUplaodHome();
  }

  displayAAdmin() {
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
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route =
                MaterialPageRoute(builder: (context) => AdminShiftOrders());
            Navigator.push(context, route);
          },
        ),
        actions: [
          FlatButton(
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (context) => SplashScreen());
                Navigator.pushReplacement(context, route);
              },
              child: Text(
                'LogOut',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: getAdninScreenBodey(),
    );
  }

  getAdninScreenBodey() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.lightGreenAccent, Colors.pink],
              begin: FractionalOffset(1.0, 0.0),
              end: FractionalOffset(1.0, 1))),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 200,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  'Add New Items',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: Colors.green,
                onPressed: () => tickImage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  tickImage(myContext) {
    showDialog(
        context: myContext,
        builder: (c) {
          return SimpleDialog(
            title: Text(
              'Itam Image',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  'Capture with Camera',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: cupturePhotoith,
              ),
              SimpleDialogOption(
                child: Text(
                  'Select from gallery',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: pickPhotoWithCom,
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  cupturePhotoith() async {
    Navigator.pop(context);
    File ImageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
    setState(() {
      file = ImageFile;
    });
  }

  pickPhotoWithCom() async {
    Navigator.pop(context);
    File ImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = ImageFile;
    });
  }

  displayUplaodHome() {
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          onPressed: clearFormInfo,
        ),
        title: Text(
          'New Product',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24.0),
        ),
        actions: [
          FlatButton(
            onPressed: upLoding ? null : () => upLodingImageToItim(),
            child: Text(
              'Add',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          upLoding ? linearProgress() : Text('a'),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(file), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(Icons.perm_device_info, color: Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                controller: _showextEditingController,
                decoration: InputDecoration(
                  hintText: 'short Info',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(Icons.perm_device_info, color: Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                controller: _titelTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(Icons.perm_device_info, color: Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                controller: _decTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.pink,
          ),
          ListTile(
            leading: Icon(Icons.perm_device_info, color: Colors.pink),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                controller: _priTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Price',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _decTextEditingController.clear();
      _showextEditingController.clear();
      _priTextEditingController.clear();
      _titelTextEditingController.clear();
    });
  }

  upLodingImageToItim() async {
    setState(() {
      upLoding = true;
    });
    String imageDawalosUrl = await uploadeItmimImage(file);
    SavaItimInfo(imageDawalosUrl);
  }

  Future<String> uploadeItmimImage(myFile) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child("Itmi");
    StorageUploadTask storageUploadTask =
        storageReference.child("product $productId.jpg").putFile(myFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
    String dionlodeUrl = await taskSnapshot.ref.getDownloadURL();
    return dionlodeUrl;
  }

  SavaItimInfo(String url) {
    final itmeRef = Firestore.instance.collection('items');
    itmeRef.document(productId).setData({
      'shortInfo': _showextEditingController.text.trim(),
      'longDescription': _decTextEditingController.text.trim(),
      'price': int.parse(_priTextEditingController.text),
      'title': _titelTextEditingController.text.trim(),
      'publishedDate': DateTime.now(),
      'thumbnailUrl': url,
      'status': 'available',
    });
    setState(() {
      file = null;
      upLoding = false;
      productId = DateTime.now().microsecondsSinceEpoch.toString();
      _decTextEditingController.clear();
      _showextEditingController.clear();
      _priTextEditingController.clear();
      _titelTextEditingController.clear();
    });
  }
}
