import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {

  int _nimberOfItems=0;
  int get nimberOfItems=>_nimberOfItems;
  displey(int no){
    _nimberOfItems=no;
    notifyListeners();
  }
}
