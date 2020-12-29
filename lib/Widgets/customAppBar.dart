
import 'package:e_c/Config/config.dart';
import 'package:e_c/Counters/cartitemcounter.dart';
import 'package:e_c/Store/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        title: Text(
          'e-shop',
          style: TextStyle(
            color: Colors.white,
            fontSize: 55.0,
            fontFamily: 'Signatra',
          ),
        ),
        centerTitle: true,
        bottom: bottom,
         actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                onPressed: () {
                  Route rote = MaterialPageRoute(builder: (c) => CartPage());
                  Navigator.push(context, rote);
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
                          builder: (context, consumer, _) {
                        return Text(
                         ( EcommerceApp.sharedPreferences
                             .getStringList(EcommerceApp.userCartList).length - 1).toString(),
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
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
