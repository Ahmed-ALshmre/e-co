import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_c/Config/config.dart';
import 'package:e_c/Counters/changeAddresss.dart';
import 'package:e_c/Models/address.dart';
import 'package:e_c/Orders/placeOrderPayment.dart';
import 'package:e_c/Widgets/customAppBar.dart';
import 'package:e_c/Widgets/loadingWidget.dart';
import 'package:e_c/Widgets/wideButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

// ignore: must_be_immutable
class Address extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final double totalAmount;
  // ignore: non_constant_identifier_names
  Address({this.totalAmount});
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Select Address',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Consumer<AddressChanger>(builder: (context, address, c) {
              return Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                stream: EcommerceApp.firestore
                    .collection(EcommerceApp.collectionUser)
                    .document(EcommerceApp.sharedPreferences
                        .getString(EcommerceApp.userUID))
                    .collection(EcommerceApp.subCollectionAddress)
                    .snapshots(),
                builder: (context, snapShot) {
                  return !snapShot.hasData
                      ? Center(
                          child: circularProgress(),
                        )
                      : snapShot.data.documents.length == 0
                          ? noAddressCard()
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapShot.data.documents.length,
                              itemBuilder: (context, index) {
                                return AddressCard(
                                  currentIndex: address.cont,
                                  value: index,
                                  addressId:
                                      snapShot.data.documents[index].documentID,
                                  totalAmount: widget.totalAmount,
                                  model: AddressModel.fromJson(
                                      snapShot.data.documents[index].data),
                                );
                              });
                },
              ));
            })
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AddAddress());
            Navigator.pushReplacement(context, route);
          },
          label: Text('Add new address'),
          backgroundColor: Colors.pink,
          icon: Icon(Icons.add_location),
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.pink.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location),
            Text('No shipment address has been saved'),
            Text('Please add shipment address'),
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final double totalAmount;
  final String addressId;
  final int currentIndex;
  final int value;

  AddressCard(
      {Key key,
      this.totalAmount,
      this.model,
      this.addressId,
      this.currentIndex,
      this.value})
      : super(key: key);
  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false)
            .disPleyResult(widget.value);
      },
      child: Card(
        color: Colors.pinkAccent.withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: widget.value,
                  groupValue: widget.currentIndex,
                  onChanged: (val) {
                    Provider.of<AddressChanger>(context, listen: false)
                        .disPleyResult(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              KeyText(
                                mas: 'Name',
                              ),
                              Text(widget.model.name),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                mas: 'Phone Number',
                              ),
                              Text(widget.model.name),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                mas: 'City',
                              ),
                              Text(widget.model.city),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                mas: 'Pin Code',
                              ),
                              Text(widget.model.pincode),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                mas: 'Flat Number',
                              ),
                              Text(widget.model.flatNumber),
                            ],
                          ),
                          TableRow(
                            children: [
                              KeyText(
                                mas: 'State',
                              ),
                              Text(widget.model.state),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.value ==
                    Provider.of<AddressChanger>(context, listen: false).cont
                ? WideButton(
                    message: 'Proceed',
                    function: () {
                      Route route = MaterialPageRoute(
                          builder: (c) => PaymentPage(
                                totalAmount: widget.totalAmount,
                                addressId: widget.addressId,
                              ));
                      Navigator.pushReplacement(context, route);
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String mas;

  KeyText({Key key, this.mas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      mas,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
