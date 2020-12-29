import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_c/Address/address.dart';
import 'package:e_c/Config/config.dart';
import 'package:e_c/Models/address.dart';
import 'package:e_c/Widgets/loadingWidget.dart';
import 'package:e_c/Widgets/orderCard.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../main.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderId;

  const OrderDetails({Key key, this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderId;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: Firestore.instance
                .collection(EcommerceApp.collectionUser)
                .document(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .document(orderId)
                .get(),
            // ignore: missing_return
            builder: (context, snapShot) {
              Map dataMap;
              if (snapShot.hasData) {
                dataMap = snapShot.data.data;
                print(dataMap);
              }
              return snapShot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          StatusBanner(
                            states: dataMap[EcommerceApp.isSuccess],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                r"$" +
                                    dataMap[EcommerceApp.totalAmount]
                                        .toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text("Order Id : " + getOrderId),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text(
                              'Order It:' +
                                  DateFormat("dd MMMM , yyyy-hh:mm aa").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap['orderTime']))),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                              future: EcommerceApp.firestore
                                  .collection('items')
                                  .where('shortInfo',
                                      whereIn: dataMap[EcommerceApp.productID])
                                  .getDocuments(),
                              // ignore: missing_return
                              builder: (context, dataSnapShot) {
                                return dataSnapShot.hasData
                                    ? OrderCard(
                                        itemCount:
                                            dataSnapShot.data.documents.length,
                                        data: dataSnapShot.data.documents,
                                      )
                                    : Center(
                                        child: circularProgress(),
                                      );
                              }),
                          Divider(
                            height: 10.0,
                          ),
                          Container(
                            child: FutureBuilder<DocumentSnapshot>(
                                future: EcommerceApp.firestore
                                    .collection(EcommerceApp.collectionUser)
                                    .document(EcommerceApp.sharedPreferences
                                        .getString(EcommerceApp.userUID))
                                    .collection(
                                        EcommerceApp.subCollectionAddress)
                                    .document(dataMap[EcommerceApp.addressID])
                                    .get(),
                                builder: (context, snap) {
                                  return snap.hasData
                                      ? ShippingDetails(
                                          model: AddressModel.fromJson(
                                              snap.data.data),
                                        )
                                      : Center(
                                          child: circularProgress(),
                                        );
                                }),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget {
  final bool states;

  const StatusBanner({Key key, this.states}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;
    states ? iconData = Icons.done : iconData = Icons.cancel;
    states ? msg = 'Successful' : iconData = Icons.cancel;
    return Container(
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
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => SystemNavigator.pop(),
            child: Icon(
              Icons.arrow_drop_down_circle,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Order Placed" + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 2.0,
          ),
          CircleAvatar(
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;

  const ShippingDetails({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            'Shipment Details',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 90,
            vertical: 5,
          ),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(
                children: [
                  KeyText(
                    mas: 'Name',
                  ),
                  Text(model.name),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    mas: 'Phone Number',
                  ),
                  Text(model.phoneNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    mas: 'City',
                  ),
                  Text(model.city),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    mas: 'Pin Code',
                  ),
                  Text(model.pincode),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    mas: 'Flat Number',
                  ),
                  Text(model.flatNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    mas: 'State',
                  ),
                  Text(model.state),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: InkWell(
              onTap: () {
                confomUserDelet(context, getOrderId);
              },
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
                width: screenWidth - 40,
                height: 50.0,
                child: Center(
                  child: Text(
                    'Confirmed || Items Received',
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confomUserDelet(BuildContext context, String morder) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .document(morder)
        .delete();
    getOrderId = "";
    Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    Navigator.pushReplacement(context, route);
    Fluttertoast.showToast(msg: 'Order has been Confirmed');
  }
}
