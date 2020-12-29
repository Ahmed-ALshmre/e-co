import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_c/Config/config.dart';
import 'package:e_c/Counters/cartitemcounter.dart';
import 'package:e_c/Store/product_page.dart';
import 'package:e_c/lang/app_locale.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';
import 'cart.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
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
        title: Text(
          AppLocale.of(context).getTranslated('app_bar'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 55.0,
            fontFamily: 'Signatra',
          ),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                onPressed: () {
                  Route route =
                      MaterialPageRoute(builder: (context) => CartPage());
                  Navigator.push(context, route);

                  // Route rote = MaterialPageRoute(builder: (c) => CartPage());
                  // Navigator.push(context, rote);
                },
              ),
              Positioned(
                child: Stack(
                  children: [
                    Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.amber,
                    ),
                    Positioned(
                      top: 3.0,
                      left: 4.0,
                      bottom: 4.0,
                      child: Consumer<CartItemCounter>(
                          builder: (context, counter, _) {
                        return Text(
                          (EcommerceApp.sharedPreferences
                                      .getStringList(EcommerceApp.userCartList)
                                      .length -
                                  1)
                              .toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500),
                        );
                      }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: SearchBoxDelegate(),
            pinned: true,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("items")
                  .limit(15)
                  .orderBy('publishedDate', descending: true)
                  .snapshots(),
              builder: (context, dataSnapShot) {
                return !dataSnapShot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        itemCount: dataSnapShot.data.documents.length,
                        crossAxisCount: 1,
                        staggeredTileBuilder: (context) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          ItemModel model = ItemModel.fromJson(
                              dataSnapShot.data.documents[index].data);
                          return sourceInfo(model, context);
                        },
                      );
              }),
        ],
      ),
    ));
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction, State set}) {
  return InkWell(
    onTap: () {
      Route rote = MaterialPageRoute(
          builder: (c) => ProductPage(
                itemModel: model,
              ));
      Navigator.push(context, rote);
    },
    splashColor: Colors.pink,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: Container(
        height: 190.0,
        width: width,
        child: Row(
          children: [
            Image.network(
              model.thumbnailUrl,
              height: 140,
              width: 140,
            ),
            SizedBox(width: 4.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            model.shortInfo,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.pink,
                        ),
                        alignment: Alignment.topLeft,
                        height: 40.0,
                        width: 43.0,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '50%',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                'OFF',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  r"Origional Price: $",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  (model.price + model.price).toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  "New Price",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  r'$',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16),
                                ),
                                Text(
                                  (model.price).toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Flexible(child: Container()),
                  Align(
                      alignment: Alignment.centerRight,
                      child: removeCartFunction == null
                          ? IconButton(
                              icon: Icon(Icons.add_shopping_cart_outlined,
                                  color: Colors.pinkAccent),
                              onPressed: () {
                                checkItemInCart(model.shortInfo, context);
                              })
                          : IconButton(
                              icon: Icon(Icons.delete,
                                  color: Colors.pinkAccent[100]),
                              onPressed: () {
                                removeCartFunction();
                                Route route = MaterialPageRoute(
                                    builder: (context) => StoreHome());
                                Navigator.push(context, route);
                              })),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150,
    width: width * .35,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(0, 5), blurRadius: 10.0, color: Colors.grey[200]),
        ]),
    child: Image.network(
      imgPath,
      height: 150,
      width: width * .34,
      fit: BoxFit.fill,
    ),
  );
}

void checkItemInCart(String productID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(productID)
      ? Fluttertoast.showToast(msg: 'This Item is already in Cart .')
      : addItemTotheCart(productID, context);
}

addItemTotheCart(String productID, BuildContext context) {
  List teampCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  teampCartList.add(productID);
  var firebaseUser = FirebaseAuth.instance;
  firebaseUser.currentUser().then((value) {
    Firestore.instance
        .collection(EcommerceApp.collectionUser)
        .document(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .updateData({'userCart': teampCartList}).then((v) async {
      Fluttertoast.showToast(msg: 'Item Added to Cart Successfully .');
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, teampCartList);
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      Provider.of<CartItemCounter>(context, listen: false).displayedResult();
    });
  });
}
