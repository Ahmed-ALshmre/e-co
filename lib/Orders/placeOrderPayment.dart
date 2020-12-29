
import 'package:e_c/Config/config.dart';
import 'package:e_c/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class PaymentPage extends StatefulWidget {
  final String addressId;
  final double totalAmount;

  PaymentPage({Key key, this.addressId, this.totalAmount}) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset('images/cash.png'),
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                  onPressed: () => addOrderData(),
                  textColor: Colors.white,
                  splashColor: Colors.deepOrange,
                  color: Colors.pink,
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Place Order',
                    style: TextStyle(fontSize: 30.0),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addOrderData() {
    writeOrderDetailsForUser({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      'orderBy': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: 'Cash  on Delivery',
      EcommerceApp.orderTime: DateTime.now().microsecond.toString(),
      EcommerceApp.isSuccess: true,
    });
    writeOrderDetailsForAdmin({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      'orderBy': EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList),
      EcommerceApp.paymentDetails: 'Cash  on Delivery',
      EcommerceApp.orderTime: DateTime.now().hour.toString(),
      EcommerceApp.isSuccess: true,
    }).whenComplete(() {
      emptyCartNew();
    });
  }

  emptyCartNew() {
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ['garbageValue']);
    List tempList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({
      EcommerceApp.userCartList: tempList,
    }).then((value) {
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayedResult();
      Fluttertoast.showToast(
          msg: 'Congratulations your order has been successfully');
      Route route = MaterialPageRoute(builder: (context) => SplashScreen());
      Navigator.pushReplacement(context, route);
    }).catchError((error) {});
  }

  // ignore: missing_return
  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
                data['orderTime'])
        .setData(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
                data['orderTime'])
        .setData(data);
  }
}
