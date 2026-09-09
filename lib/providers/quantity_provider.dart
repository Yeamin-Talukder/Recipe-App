import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int _currentNumber = 1;
  List<double> _baseIngredientAmounts = [];

  int get currentNumber => _currentNumber;

  void setBaseAmounts(List<double> amounts) {
    _baseIngredientAmounts = amounts;
    _currentNumber = 1;
    notifyListeners();
  }

  void reset() {
    _currentNumber = 1;
    _baseIngredientAmounts = [];
    notifyListeners();
  }

  List<String> get updateIngredientAmounts {
    return _baseIngredientAmounts
        .map<String>((amount) => (amount * _currentNumber).toStringAsFixed(1))
        .toList();
  }

  void increaseQuantity() {
    _currentNumber++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_currentNumber > 1) {
      _currentNumber--;
      notifyListeners();
    }
  }
}
