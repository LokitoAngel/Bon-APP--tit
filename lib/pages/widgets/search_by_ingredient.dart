import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Recipe {
  final String name;
  final String image;
  final int tiempoPreparacion;
  final num estrellas;
  final List<dynamic> ingredientes;

  Recipe({
    required this.name,
    required this.image,
    required this.tiempoPreparacion,
    required this.estrellas,
    required this.ingredientes,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    name: json['nombre'] as String,
    image: json['imagen'] as String,
    tiempoPreparacion: json['tiempoPreparacion'] as int,
    estrellas: json['estrellas'] as num,
    ingredientes: json['ingredientes'] as List<dynamic>,
  );
}

class ByIngredient extends StatefulWidget {
  const ByIngredient({super.key});

  @override
  State createState() => _ByIngredientState();
}

class _ByIngredientState extends State<ByIngredient> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _ingredients = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Cargar el archivo JSON
      final String jsonString = await rootBundle.loadString(
        'assets/General.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Filtrar recetas basadas en los ingredientes actuales
      _filterRecipes(jsonData);
    } catch (e) {
      print('Error al cargar recetas: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterRecipes(Map<String, dynamic> jsonData) {
    if (_ingredients.isEmpty) {
      // Si no hay ingredientes seleccionados, mostrar todas las recetas
      setState(() {
        _filteredRecipes =
            (jsonData['recetas'] as List)
                .map((recipe) => Recipe.fromJson(recipe))
                .toList();
      });
      return;
    }

    // Filtrar recetas que contengan al menos uno de los ingredientes seleccionados
    final List<Recipe> allRecipes = jsonData['recetas'];
    final List<Recipe> filtered =
        allRecipes.where((recipe) {
          final List<dynamic> recipeIngredients = recipe.ingredientes;

          // Verificar si alguno de los ingredientes de la receta coincide con los seleccionados
          for (var ing in recipeIngredients) {
            String ingredientName = ing['ingrediente'].toString().toLowerCase();
            for (var selectedIng in _ingredients) {
              if (ingredientName.contains(selectedIng.toLowerCase())) {
                return true;
              }
            }
          }
          return false;
        }).toList();

    setState(() {
      _filteredRecipes = filtered;
    });
  }

  void _addIngredient() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _ingredients.add(text);
      _controller.clear();
    });

    // Recargar y filtrar recetas cuando se agrega un nuevo ingrediente
    _loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input y botón de add
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Ingresa un ingrediente",
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.deepOrangeAccent),
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.add,
                  size: 20,
                  color: Colors.deepOrangeAccent,
                ),
                onPressed: _addIngredient,
              ),
            ),
            onSubmitted: (value) => _addIngredient(),
          ),
        ),

        // Lista de ingredientes
        Container(
          width: double.infinity,
          height: 150,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              _ingredients.isEmpty
                  ? const Center(child: Text("No hay ingredientes añadidos"))
                  : ListView.builder(
                    itemCount: _ingredients.length,
                    itemBuilder: (context, idx) {
                      final ing = _ingredients[idx];
                      return ListTile(
                        leading: const Icon(Icons.circle, size: 8),
                        title: Text(ing),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() {
                              _ingredients.removeAt(idx);
                              // Recargar y filtrar recetas cuando se elimina un ingrediente
                              _loadRecipes();
                            });
                          },
                        ),
                      );
                    },
                  ),
        ),

        const Text(
          "Recetas",
          style: TextStyle(fontSize: 22, color: Colors.deepOrangeAccent),
        ),

        // Mostrar cargando o la lista de recetas
        _isLoading
            ? const CircularProgressIndicator(color: Colors.deepOrangeAccent)
            : ListRecepies(filteredList: _filteredRecipes),
      ],
    );
  }
}

class ListRecepies extends StatelessWidget {
  const ListRecepies({super.key, required this.filteredList});
  final List<Recipe> filteredList;

  @override
  Widget build(BuildContext context) {
    if (filteredList.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text("No se encontraron recetas con estos ingredientes"),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final recipe = filteredList[index];
          return CardIngredient(recipe: recipe);
        },
      ),
    );
  }
}

class CardIngredient extends StatelessWidget {
  CardIngredient({super.key, required this.recipe});

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
