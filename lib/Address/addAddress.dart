
import 'package:e_c/Config/config.dart';
import 'package:e_c/Models/address.dart';
import 'package:e_c/Widgets/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<FormState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHome = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPineCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (formKey.currentState.validate()) {
              final mode = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                phoneNumber: cPhoneNumber.text.trim(),
                pincode: cPineCode.text.trim(),
                city: cCity.text.trim(),
                flatNumber: cFlatHome.text.trim(),
              ).toJson();
              // coll to the Firebase here
              EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .document(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .document(DateTime.now().millisecond.toString())
                  .setData(mode)
                  .then((value) {
                Fluttertoast.showToast(msg: 'New  Address added Successfully .');
                 Text(' ');

                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
              });
            }
          },
          label: Text('Done'),
          backgroundColor: Colors.pink,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Add new address',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    MyTextField(
                      hint: 'Name',
                      controller: cName,
                    ),
                    MyTextField(
                      hint: 'Phone Number',
                      controller: cPhoneNumber,
                    ),
                    MyTextField(
                      hint: 'Flat Number / House Number',
                      controller: cFlatHome,
                    ),
                    MyTextField(
                      hint: 'City',
                      controller: cCity,
                    ),
                    MyTextField(
                      hint: 'State/Country',
                      controller: cState,
                    ),
                    MyTextField(
                      hint: 'Pin code',
                      controller: cPineCode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  MyTextField({this.controller, this.hint});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val.isEmpty ? 'Field can not be empty' : null,
      ),
    );
  }
}
