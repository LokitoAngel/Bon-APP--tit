import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../theme/theme.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final imageController = TextEditingController();
  final authorController = TextEditingController();
  final timeController = TextEditingController();
  final servingsController = TextEditingController();
  final videoController = TextEditingController();

  List<Map<String, String>> ingredients = [];
  List<String> steps = [];

  String? currentIngredient;
  String? currentQuantity;
  String? currentStep;

  int selectedIndex = 2;

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

  void addRecipe() {
    if (!_formKey.currentState!.validate()) return;
    if (ingredients.isEmpty || steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Add at least one ingredient and one step"),
          backgroundColor: Color.fromARGB(255, 255, 0, 0),
        ),
      );
      return;
    }

    final receta = {
      'nombre': nameController.text,
      'imagen': imageController.text,
      'autor': authorController.text,
      'tiempoPreparacion': int.tryParse(timeController.text) ?? 0,
      'porciones': int.tryParse(servingsController.text) ?? 0,
      'estrellas': 5.0,
      'ingredientes': ingredients,
      'pasos': steps,
      'categoria': ['User'],
      'video': videoController.text,
      'totalIngredientes': ingredients.length,
    };

    Provider.of<FavoritesProvider>(
      context,
      listen: false,
    ).toggleFavorite(receta);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Recipe added to favorites"),
        backgroundColor: Colors.green,
      ),
    );

    nameController.clear();
    imageController.clear();
    authorController.clear();
    timeController.clear();
    servingsController.clear();
    videoController.clear();
    setState(() {
      ingredients.clear();
      steps.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final texto = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final tarjeta = theme.cardColor;
    final acento = theme.colorScheme.secondary;
    final primario = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text("Add Recipe"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: tarjeta,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _field("Recipe name", nameController),
                  _field("Image URL", imageController),
                  _field("Author", authorController),
                  _field(
                    "Preparation time (min)",
                    timeController,
                    isNumber: true,
                  ),
                  _field("Servings", servingsController, isNumber: true),
                  _field("YouTube video URL (optional)", videoController),

                  const SizedBox(height: 12),
                  Divider(color: texto.withOpacity(0.4)),
                  const SizedBox(height: 8),
                  const Text(
                    "Ingredients",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Quantity",
                          ),
                          style: TextStyle(color: texto),
                          onChanged: (v) => currentQuantity = v,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Ingredient",
                          ),
                          style: TextStyle(color: texto),
                          onChanged: (v) => currentIngredient = v,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (currentIngredient?.isNotEmpty == true &&
                              currentQuantity?.isNotEmpty == true) {
                            setState(() {
                              ingredients.add({
                                'ingrediente': currentIngredient!,
                                'cantidad': currentQuantity!,
                              });
                              currentIngredient = '';
                              currentQuantity = '';
                            });
                          }
                        },
                        icon: Icon(Icons.add, color: acento),
                      ),
                    ],
                  ),

                  Wrap(
                    spacing: 8,
                    children:
                        ingredients
                            .map(
                              (ing) => Chip(
                                label: Text(
                                  "${ing['cantidad']} ${ing['ingrediente']}",
                                ),
                                backgroundColor: acento.withOpacity(0.2),
                                deleteIconColor: acento,
                                onDeleted:
                                    () =>
                                        setState(() => ingredients.remove(ing)),
                              ),
                            )
                            .toList(),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    "Steps",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Step description",
                          ),
                          style: TextStyle(color: texto),
                          onChanged: (v) => currentStep = v,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (currentStep?.isNotEmpty == true) {
                            setState(() {
                              steps.add(currentStep!);
                              currentStep = '';
                            });
                          }
                        },
                        icon: Icon(Icons.add, color: acento),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      steps.length,
                      (i) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "${i + 1}. ${steps[i]}",
                          style: TextStyle(color: texto),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: acento),
                          onPressed: () => setState(() => steps.removeAt(i)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primario,
                        foregroundColor: Colors.white,

                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: addRecipe,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text("Agregar receta"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        backgroundColor: theme.scaffoldBackgroundColor,
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

  Widget _field(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        validator:
            (value) =>
                (value == null || value.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }
}
