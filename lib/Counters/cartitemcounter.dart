import 'package:e_c/Config/config.dart';
import 'package:flutter/foundation.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter = EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList).length - 1;
  int get count => _counter;
  Future<void> displayedResult() async {
    int _counter = EcommerceApp.sharedPreferences
            .getStringList(EcommerceApp.userCartList).length -1;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
