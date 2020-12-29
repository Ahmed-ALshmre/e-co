import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_c/Models/item.dart';
import 'package:e_c/Store/storehome.dart';


import 'package:flutter/material.dart';

import 'adminOrderDetails.dart';

int counter = 0;

class AdminOrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderId;
  final String addressId;
  final String orderBy;

  const AdminOrderCard(
      {Key key,
      this.itemCount,
      this.data,
      this.orderId,
      this.addressId,
      this.orderBy})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route;
        if (counter == 0) {
          counter = counter + 1;
          route = MaterialPageRoute(
              builder: (context) => AdminOrderDetails(
                    orderId: orderId,
                    orderBy: orderId,
                    addressId: addressId,
                  ));
        }
        Navigator.push(context, route);
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
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        height: itemCount * 190.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            ItemModel model = ItemModel.fromJson(data[index].data);
            return sourceInfo(model, context);
          },
        ),
      ),
    );
  }
}
