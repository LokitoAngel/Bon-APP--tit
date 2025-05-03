import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Recipe {
  final String name;
  final String image;
  final int tiempoPreparacion;
  final num estrellas;

  Recipe({
    required this.name,
    required this.image,
    required this.tiempoPreparacion,
    required this.estrellas,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    name: json['nombre'] as String,
    image: json['imagen'] as String,
    tiempoPreparacion: json['tiempoPreparacion'] as int,
    estrellas: json['estrellas'] as num,
  );
}

class ByName extends StatefulWidget {
  const ByName({super.key});

  @override
  State<ByName> createState() => _ByNameState();
}

class _ByNameState extends State<ByName> {
  final TextEditingController _controller = TextEditingController();
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _controller.addListener(_filter);
  }

  Future<void> _loadRecipes() async {
    final jsonStr = await rootBundle.loadString('assets/General.json');
    final Map<String, dynamic> data = json.decode(jsonStr);
    final List<dynamic> list = data['recetas'];
    setState(() {
      _allRecipes = list.map((e) => Recipe.fromJson(e)).toList();
      _filteredRecipes = List.from(_allRecipes);
    });
  }

  void _filter() {
    final query = _controller.text.toLowerCase();
    setState(() {
      _filteredRecipes =
          _allRecipes.where((r) {
            return r.name.toLowerCase().contains(query);
          }).toList();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_filter);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Enter recipe name",
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.deepOrangeAccent),
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.deepOrangeAccent,
                ),
                onPressed: _filter,
              ),
            ),
          ),
        ),
        Expanded(
          child:
              _filteredRecipes.isEmpty
                  ? const Center(child: Text("No matches found"))
                  : ListView.builder(
                    itemCount: _filteredRecipes.length,
                    itemBuilder: (context, idx) {
                      final recipe = _filteredRecipes[idx];
                      return SearchCard(recipe: recipe);
                    },
                  ),
        ),
      ],
    );
  }
}

class SearchCard extends StatelessWidget {
  const SearchCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            recipe.image,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              );
            },
          ),
        ),
        title: Text(
          recipe.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text("Tiempo: ${recipe.tiempoPreparacion} min"),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                Text(" ${recipe.estrellas}"),
              ],
            ),
          ],
        ),
        onTap: () {
          // Aquí puedes navegar a la página de detalles de la receta
          print("Receta seleccionada: ${recipe.name}");
        },
      ),
    );
  }
}
