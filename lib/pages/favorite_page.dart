import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int selectedIndex = 1;

  void onItemTapped(int index) {
    setState(() => selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, 'home_page');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, 'favorite_page');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, 'add');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, 'lista');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, 'perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = Provider.of<FavoritesProvider>(context).favorites;

    final theme = Theme.of(context);
    final fondo = theme.scaffoldBackgroundColor;
    final texto = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final tarjeta = theme.cardColor;
    final primario = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: primario,
        title: const Text("Favorites"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body:
          favoritos.isEmpty
              ? Center(
                child: Text(
                  "No favorites yet",
                  style: TextStyle(color: texto, fontSize: 16),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: favoritos.length,
                itemBuilder: (context, index) {
                  final receta = favoritos[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          'recipe_detail',
                          arguments: receta,
                        );
                      },
                      child: Card(
                        color: tarjeta,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(16),
                              ),
                              child: Image.network(
                                receta['imagen'],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image),
                                    ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      receta['nombre'],
                                      style: TextStyle(
                                        color: texto,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${receta['tiempoPreparacion']} min",
                                      style: TextStyle(
                                        color: texto.withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${receta['estrellas']}",
                                          style: TextStyle(
                                            color: texto.withOpacity(0.9),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        backgroundColor: fondo,
        selectedItemColor: primario,
        unselectedItemColor: texto.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 32),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'List',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
        ],
      ),
    );
  }
}
