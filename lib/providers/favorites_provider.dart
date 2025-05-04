import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  void toggleFavorite(Map<String, dynamic> receta) {
    final exists = _favorites.any((r) => r['nombre'] == receta['nombre']);
    if (exists) {
      _favorites.removeWhere((r) => r['nombre'] == receta['nombre']);
    } else {
      _favorites.add(receta);
    }
    notifyListeners();
  }

  bool isFavorite(String nombre) {
    return _favorites.any((r) => r['nombre'] == nombre);
  }
}
