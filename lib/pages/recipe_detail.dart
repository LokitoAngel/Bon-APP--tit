import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../providers/favorites_provider.dart';
import '../providers/list_provider.dart';

class RecipeDetailPage extends StatefulWidget {
  const RecipeDetailPage({super.key});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  YoutubePlayerController? _youtubeController;

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> receta =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final listProvider = Provider.of<ListProvider>(context);
    final bool isFavorite = favoritesProvider.isFavorite(receta['nombre']);
    final bool isInList = listProvider.recipes.any(
      (r) => r['nombre'] == receta['nombre'],
    );

    final Color naranja = const Color(0xFFFF6B35);
    final Color crema = const Color(0xFFFFF5E0);
    final Color textoFuerte = const Color(0xFF3D2C1F);

    final String videoUrl = receta['video'];
    final String? videoId = YoutubePlayer.convertUrlToId(videoUrl);

    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    }

    return Scaffold(
      backgroundColor: crema,
      appBar: AppBar(
        backgroundColor: naranja,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(receta['nombre']),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              final wasAdded = !isFavorite;
              favoritesProvider.toggleFavorite(receta);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    wasAdded ? 'Added to favorites' : 'Removed from favorites',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: wasAdded ? Colors.green : Colors.red,
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              isInList ? Icons.shopping_cart : Icons.add_shopping_cart,
              color: Colors.white,
            ),
            tooltip: 'Add to shopping list',
            onPressed: () {
              if (!isInList) {
                listProvider.addToList(receta);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Recipe added to shopping list"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Recipe is already in the shopping list"),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  receta['imagen'],
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 220,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'by ${receta['autor']}',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: textoFuerte,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber.shade600, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${receta['estrellas']}/5.0',
                        style: TextStyle(color: textoFuerte),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.group, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${receta['porciones']} servings',
                        style: TextStyle(color: textoFuerte),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.shopping_basket, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${receta['totalIngredientes']} ingredients',
                        style: TextStyle(color: textoFuerte),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _sectionTitle("Ingredients"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.from(
                  (receta['ingredientes'] as List).map(
                    (ing) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Text("• ", style: TextStyle(fontSize: 18)),
                          Expanded(
                            child: Text(
                              '${ing['cantidad']} ${ing['ingrediente']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: textoFuerte,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _sectionTitle("Steps to complete"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: List.generate(
                  (receta['pasos'] as List).length,
                  (i) => ListTile(
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: naranja,
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    title: Text(
                      receta['pasos'][i],
                      style: TextStyle(color: textoFuerte),
                    ),
                    contentPadding: const EdgeInsets.only(bottom: 12),
                  ),
                ),
              ),
            ),
            if (_youtubeController != null) ...[
              _sectionTitle("Watch the recipe"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: YoutubePlayer(
                  controller: _youtubeController!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: naranja,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
