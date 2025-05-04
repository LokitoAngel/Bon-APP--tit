import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../theme/theme_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/list_provider.dart';

class RecipesByCategoryPage extends StatelessWidget {
  const RecipesByCategoryPage({super.key});

  Future<List<Map<String, dynamic>>> cargarRecetas() async {
    final String data = await rootBundle.loadString('assets/General.json');
    final Map<String, dynamic> jsonResult = json.decode(data);
    return List<Map<String, dynamic>>.from(jsonResult['recetas']);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final listProvider = Provider.of<ListProvider>(context);

    final isDark = themeProvider.isDarkMode;
    final fondo = theme.scaffoldBackgroundColor;
    final texto = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final tarjeta = theme.cardColor;
    final primario = theme.colorScheme.primary;

    final String categoria =
        ModalRoute.of(context)?.settings.arguments as String;

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: primario,
        title: Text(categoria),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: cargarRecetas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primario));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No recipes available',
                style: TextStyle(color: texto),
              ),
            );
          }

          final recetas = snapshot.data!;
          final recetasCat =
              recetas.where((r) => r['categoria'].contains(categoria)).toList();

          return ListView.builder(
            itemCount: recetasCat.length,
            itemBuilder: (context, i) {
              final receta = recetasCat[i];
              final isFav = favoritesProvider.isFavorite(receta['nombre']);
              final isInList = listProvider.recipes.any(
                (r) => r['nombre'] == receta['nombre'],
              );

              return Card(
                color: tarjeta,
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      'recipe_detail',
                      arguments: receta,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(receta['imagen']),
                          radius: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                receta['nombre'],
                                style: TextStyle(
                                  color: texto,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${receta['tiempoPreparacion']} min • ${receta['estrellas']}★ • ${receta['porciones']} servings',
                                style: TextStyle(
                                  color: texto.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      final wasAdded = !isFav;
                                      favoritesProvider.toggleFavorite(receta);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            wasAdded
                                                ? 'Added to favorites'
                                                : 'Removed from favorites',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor:
                                              wasAdded
                                                  ? Colors.green
                                                  : Colors.red,
                                          duration: const Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          margin: const EdgeInsets.all(16),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isInList
                                          ? Icons.shopping_cart
                                          : Icons.add_shopping_cart,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      final wasAdded = !isInList;
                                      if (wasAdded) {
                                        listProvider.addToList(receta);
                                      } else {
                                        listProvider.removeFromList(receta);
                                      }
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            wasAdded
                                                ? 'Added to shopping list'
                                                : 'Removed from shopping list',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor:
                                              wasAdded
                                                  ? Colors.green
                                                  : Colors.red,
                                          duration: const Duration(seconds: 2),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          margin: const EdgeInsets.all(16),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
