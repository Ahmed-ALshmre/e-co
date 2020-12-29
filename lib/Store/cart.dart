
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_c/Address/address.dart';
import 'package:e_c/Config/config.dart';
import 'package:e_c/Counters/cartitemcounter.dart';
import 'package:e_c/Counters/totalMoney.dart';
import 'package:e_c/Models/item.dart';
import 'package:e_c/Store/storehome.dart';
import 'package:e_c/Widgets/customAppBar.dart';
import 'package:e_c/Widgets/loadingWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;
  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).disPley(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // ignore: unrelated_type_equality_checks
          if (EcommerceApp.sharedPreferences
                  .getStringList(EcommerceApp.userCartList)
                  .length ==
              1) {
            Fluttertoast.showToast(msg: 'your Cart is empty');
          } else {
            Route route = MaterialPageRoute(
                builder: (context) => Address(
                      totalAmount: totalAmount,
                    ));
            Navigator.push(context, route);
          }
        },
        label: Text('Check out'),
        backgroundColor: Colors.pinkAccent,
        icon: Icon(Icons.navigate_next),
      ),
      appBar: MyAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            // ignore: missing_return
            child: Consumer2<TotalAmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: EcommerceApp.sharedPreferences
                                .getStringList(EcommerceApp.userCartList)
                                .length ==
                            1
                        ? Container()
                        : Text(
                            "Total Price : ${amountProvider.total.toString()}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                  ),
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: EcommerceApp.firestore
                  .collection('items')
                  .where('shortInfo',
                      whereIn: EcommerceApp.sharedPreferences
                          .getStringList(EcommerceApp.userCartList))
                  .snapshots(),
              builder: (c, snapshots) {
                return !snapshots.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : snapshots.data.documents.length == 0
                        ? beginbuilng()
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                                // ignore: missing_return
                                (context, index) {
                            ItemModel mode = ItemModel.fromJson(
                                snapshots.data.documents[index].data);
                            if (index == 0) {
                              totalAmount = 0;
                              totalAmount = mode.price + totalAmount;
                            } else {
                              totalAmount = mode.price + totalAmount;
                            }
                            if (snapshots.data.documents.length - 1 == index) {
                              WidgetsBinding.instance.addPostFrameCallback((t) {
                                Provider.of<TotalAmount>(context, listen: false)
                                    .disPley(totalAmount);
                              });
                            }
                            return sourceInfo(mode, context,
                                removeCartFunction: () =>
                                    removeItemUserCart(mode.shortInfo));
                          },
                                childCount: snapshots.hasData
                                    ? snapshots.data.documents.length
                                    : 0));
              }),
        ],
      ),
    );
  }

  removeItemUserCart(String shortInfoId) {
    List teampCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    teampCartList.remove(shortInfoId);
    var firebaseUser = FirebaseAuth.instance;
    firebaseUser.currentUser().then((value) {
      Firestore.instance
          .collection(EcommerceApp.collectionUser)
          .document(
              EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
          .updateData({'userCart': teampCartList}).then((v) async {
        Fluttertoast.showToast(msg: 'Item remove to Cart Successfully .');
        EcommerceApp.sharedPreferences
            .setStringList(EcommerceApp.userCartList, teampCartList);
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        Provider.of<CartItemCounter>(context, listen: false).displayedResult();
        totalAmount = 0;
        setState(() {});
      });
    });
  }

  beginbuilng() {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_emoticon,
                color: Colors.white,
              ),
              Text('Cart is empty .'),
              Text('Start adding items to your Cart '),
            ],
          ),
        ),
      ),
    );
  }
}
