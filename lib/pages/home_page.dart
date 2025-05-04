import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../theme/theme_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/list_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  Future<List<Map<String, dynamic>>> cargarRecetas() async {
    final String data = await rootBundle.loadString('assets/General.json');
    final Map<String, dynamic> jsonResult = json.decode(data);
    return List<Map<String, dynamic>>.from(jsonResult['recetas']);
  }

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
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final listProvider = Provider.of<ListProvider>(context);

    final isDark = themeProvider.isDarkMode;
    final fondo = theme.scaffoldBackgroundColor;
    final texto = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final tarjeta = theme.cardColor;
    final acento = theme.colorScheme.secondary;
    final primario = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        backgroundColor: primario,
        title: const Text('Recipes'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'search');
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: () {
              themeProvider.toggleTheme(!isDark);
            },
          ),
        ],
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
          final categorias =
              recetas
                  .expand((r) => List<String>.from(r['categoria']))
                  .toSet()
                  .toList();

          return ListView.builder(
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final categoria = categorias[index];
              final recetasCat =
                  recetas
                      .where((r) => r['categoria'].contains(categoria))
                      .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          categoria,
                          style: TextStyle(
                            color: texto,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              'recipes_by_category',
                              arguments: categoria,
                            );
                          },
                          child: Text(
                            "View more",
                            style: TextStyle(
                              color: acento,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 310,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recetasCat.length,
                      itemBuilder: (context, i) {
                        final receta = recetasCat[i];
                        final isFav = favoritesProvider.isFavorite(
                          receta['nombre'],
                        );
                        final isInList = listProvider.recipes.any(
                          (r) => r['nombre'] == receta['nombre'],
                        );

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 180,
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
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                        child: Image.network(
                                          receta['imagen'],
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          receta['nombre'],
                                          style: TextStyle(
                                            color: texto,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  size: 16,
                                                  color: Colors.amber,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${receta['estrellas']}',
                                                  style: TextStyle(
                                                    color: texto,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.group,
                                                      size: 16,
                                                      color: Colors.blueGrey,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${receta['porciones']}',
                                                      style: TextStyle(
                                                        color: texto,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.timer_outlined,
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${receta['tiempoPreparacion']} min',
                                                      style: TextStyle(
                                                        color: texto,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
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
                                                    favoritesProvider
                                                        .toggleFavorite(receta);
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          wasAdded
                                                              ? 'Added to favorites'
                                                              : 'Removed from favorites',
                                                          style:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                        ),
                                                        backgroundColor:
                                                            wasAdded
                                                                ? Colors.green
                                                                : Colors.red,
                                                        duration:
                                                            const Duration(
                                                              seconds: 2,
                                                            ),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                        margin:
                                                            const EdgeInsets.all(
                                                              16,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    isInList
                                                        ? Icons.shopping_cart
                                                        : Icons
                                                            .add_shopping_cart,
                                                    color: const Color.fromARGB(
                                                      255,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    final wasAdded = !isInList;
                                                    if (wasAdded) {
                                                      listProvider.addToList(
                                                        receta,
                                                      );
                                                    } else {
                                                      listProvider
                                                          .removeFromList(
                                                            receta,
                                                          );
                                                    }
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          wasAdded
                                                              ? 'Added to shopping list'
                                                              : 'Removed from shopping list',
                                                          style:
                                                              const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                        ),
                                                        backgroundColor:
                                                            wasAdded
                                                                ? Colors.green
                                                                : Colors.red,
                                                        duration:
                                                            const Duration(
                                                              seconds: 2,
                                                            ),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                        margin:
                                                            const EdgeInsets.all(
                                                              16,
                                                            ),
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
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: fondo,
        currentIndex: selectedIndex,
        selectedItemColor: primario,
        unselectedItemColor: texto.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        onTap: onItemTapped,
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
