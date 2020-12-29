import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_c/Config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';
import 'adminOrderCard.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
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
          centerTitle: true,
          title: Text(
            'My Order',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Colors.white,
                ),
                onPressed: () {
                  SystemNavigator.pop();
                }),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("orders").snapshots(),
          builder: (context, snapShots) {
            return snapShots.hasData
                ? ListView.builder(
                    itemCount: snapShots.data.documents.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<QuerySnapshot>(
                          future: Firestore.instance
                              .collection('items')
                              .where('shortInfo',
                                  whereIn: snapShots.data.documents[index]
                                      .data[EcommerceApp.productID])
                              .getDocuments(),
                          builder: (context, snap) {
                            return snap.hasData
                                ? AdminOrderCard(
                                    itemCount: snap.data.documents.length,
                                    data: snap.data.documents,
                                    orderId: snapShots
                                        .data.documents[index].documentID,
                                    orderBy: snapShots
                                        .data.documents[index].data['orderBy'],
                                    addressId: snapShots.data.documents[index]
                                        .data['addressId'],
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          });
                    })
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
