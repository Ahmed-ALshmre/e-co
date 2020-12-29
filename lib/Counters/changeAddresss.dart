
import 'package:flutter/foundation.dart';

class AddressChanger extends ChangeNotifier{
  int _counter=0;
  int get cont=>_counter;
  disPleyResult(int v){
    _counter=v;
    notifyListeners();
  }
}