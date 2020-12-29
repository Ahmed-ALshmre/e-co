import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_c/Address/address.dart';
import 'package:e_c/Admin/uploadItems.dart';
import 'package:e_c/Config/config.dart';
import 'package:e_c/Models/address.dart';
import 'package:e_c/Widgets/loadingWidget.dart';
import 'package:e_c/Widgets/orderCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderId = "";
class AdminOrderDetails extends StatelessWidget {
  final String orderId;
  final String orderBy;
  final String addressId;

  const AdminOrderDetails({Key key, this.orderId, this.orderBy, this.addressId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderId;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future:Firestore.instance.
            collection(EcommerceApp.collectionOrders)
                .document(getOrderId).get(),


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
                    AdminStatusBanner(
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
                        style: TextStyle(color: Colors.grey , fontSize: 16),
                      ),
                    ),
                    Divider(
                      height: 2.0,
                    ),
                    FutureBuilder<QuerySnapshot>
                      (
                        future: EcommerceApp.firestore.collection('items')
                            .where('shortInfo' , whereIn: dataMap[EcommerceApp.productID])
                            .getDocuments(),
                        // ignore: missing_return
                        builder: (context , dataSnapShot){
                          return dataSnapShot.hasData?
                          OrderCard(
                            itemCount: dataSnapShot.data.documents.length,
                            data: dataSnapShot.data.documents,
                          )
                              :Center(child: circularProgress(),);
                        }),
                    Divider(height: 10.0,),
                    Container(
                      child: FutureBuilder<DocumentSnapshot>(
                          future: EcommerceApp.firestore
                          .collection(EcommerceApp.collectionUser)
                          .document(orderBy)
                          .collection(EcommerceApp.subCollectionAddress)
                          .document(addressId)
                          .get(),
                          builder: (
                          context , snap){
                            return snap.hasData?
                            AdminShippingDetails(
                              model: AddressModel.fromJson(snap.data.data),
                            ):
                            Center(child: circularProgress(),);
                          }),
                    ),
                  ],
                ),
              )
                  : Center(child: circularProgress(),);
            },
          ),
        ),
      ),
    );
  }
}

class AdminStatusBanner extends StatelessWidget {

  final bool states;

  const AdminStatusBanner({Key key, this.states}) : super(key: key);

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




class AdminShippingDetails extends StatelessWidget {
  final AddressModel model;

  const AdminShippingDetails({Key key, this.model}) : super(key: key);
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
                confomUserDeletAdmin(context, getOrderId);
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

  confomUserDeletAdmin(BuildContext context, String myOrder) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .document(myOrder)
        .delete();
    getOrderId = "";
    Route route = MaterialPageRoute(builder: (c) => UploadPage());
    Navigator.pushReplacement(context, route);
    Fluttertoast.showToast(msg: 'Order has been Confirmed');

  }

}


