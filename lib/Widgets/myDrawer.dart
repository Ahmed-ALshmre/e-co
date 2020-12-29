
import 'package:e_c/Authentication/authenication.dart';
import 'package:e_c/Config/config.dart';
import 'package:e_c/Orders/myOrders.dart';
import 'package:e_c/Store/Search.dart';
import 'package:e_c/Store/cart.dart';
import 'package:e_c/Store/storehome.dart';
import 'package:e_c/lang/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MyDrawer extends StatelessWidget {
  String im =
      EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl);
  String text = EcommerceApp.sharedPreferences.getString(
    EcommerceApp.userName,
  );
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
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
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.circular(80),
                  elevation: 10,
                  child: Container(
                    height: 160,
                    width: 160,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage("$im"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "$text",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    fontFamily: 'Signatra',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
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
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: Text(
                  AppLocale.of(context).getTranslated('home'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (context) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  thickness: 6,
                  color: Colors.white,
                ),
                ListTile(
                  leading: Icon(
                    Icons.reorder,
                    color: Colors.white,
                  ),
                  title: Text(
    AppLocale.of(context).getTranslated('my_Order'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (context) => MyOrders());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  thickness: 6,
                  color: Colors.white,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    AppLocale.of(context).getTranslated('my_Cart'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (context) => CartPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  thickness: 6,
                  color: Colors.white,
                ),
                ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  title: Text(
                    AppLocale.of(context).getTranslated('search'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => SearchProduct());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  thickness: 6,
                  color: Colors.white,
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_location,
                    color: Colors.white,
                  ),
                  title: Text(
                    AppLocale.of(context).getTranslated('add_New_Address'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => AuthenticScreen());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  thickness: 6,
                  color: Colors.white,
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  title: Text(
                    AppLocale.of(context).getTranslated('logout'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    EcommerceApp.auth.signOut().then((value) {
                      Route route = MaterialPageRoute(
                          builder: (context) => AuthenticScreen());
                      Navigator.pushReplacement(context, route);
                    });
                  },
                ),
                Divider(
                  height: 10.0,
                  thickness: 6,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
