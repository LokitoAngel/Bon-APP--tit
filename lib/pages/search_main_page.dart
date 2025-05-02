import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Recipe {
  final String name;
  final String image;
  final int tiempoPreparacion;

  Recipe({
    required this.name,
    required this.image,
    required this.tiempoPreparacion,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    name: json['nombre'] as String,
    image: json['imagen'] as String,
    tiempoPreparacion: json['tiempoPreparacion'] as int,
  );
}

class SearchMain extends StatefulWidget {
  const SearchMain({super.key});

  @override
  State<SearchMain> createState() => _SearchMainState();
}

class _SearchMainState extends State<SearchMain> {
  int _selectedButtonIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Recipes")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextButton("By name", 0),
              _buildTextButton("By category", 1),
              _buildTextButton("By ingredient", 2),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedButtonIndex,
              children: [
                ByName(),
                const Center(child: Text("Search by category")),
                const Center(child: Text("Search by ingredient")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(String text, int index) {
    final isSelected = _selectedButtonIndex == index;
    return TextButton(
      onPressed: () => setState(() => _selectedButtonIndex = index),
      child: Text(
        text,
        style: TextStyle(color: isSelected ? Colors.orangeAccent : null),
      ),
    );
  }
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
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, size: 20),
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
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Container(
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              // Imagen a la izquierda, ocupa toda la altura
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  recipe.image,
                                  width: 100,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Texto y tiempo + ícono
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          "${recipe.tiempoPreparacion} min",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.bookmark_border,
                                          color:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodyLarge!.color,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
