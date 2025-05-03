import 'package:flutter/material.dart';

class ListProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _recipes = [];

  List<Map<String, dynamic>> get recipes => _recipes;

  void addToList(Map<String, dynamic> recipe) {
    if (!_recipes.any((r) => r['nombre'] == recipe['nombre'])) {
      _recipes.add(recipe);
      notifyListeners();
    }
  }

  void removeFromList(Map<String, dynamic> recipe) {
    _recipes.removeWhere((r) => r['nombre'] == recipe['nombre']);
    notifyListeners();
  }

  void clearList() {
    _recipes.clear();
    notifyListeners();
  }

  bool isInList(String nombre) {
    return _recipes.any((r) => r['nombre'] == nombre);
  }

  void toggleInList(Map<String, dynamic> recipe) {
    if (isInList(recipe['nombre'])) {
      removeFromList(recipe);
    } else {
      addToList(recipe);
    }
  }
}
