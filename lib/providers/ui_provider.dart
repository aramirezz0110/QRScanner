import 'package:flutter/cupertino.dart';

class UIProvider extends ChangeNotifier {
  int _selectedMenuOpt = 0;
  int get selectedMenuOpt {
    return _selectedMenuOpt;
  }

  set selectedMenuOpt(int value) {
    _selectedMenuOpt = value;
    //para avisar a los demas widgets que hubo un cambio
    notifyListeners();
  }
}
