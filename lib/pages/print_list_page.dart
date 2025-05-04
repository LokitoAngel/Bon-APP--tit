import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/list_provider.dart';
import '../theme/theme_provider.dart';

class PrintListPage extends StatelessWidget {
  const PrintListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context);
    final theme = Theme.of(context);
    final texto = theme.textTheme.bodyMedium?.color ?? Colors.black;

    final Map<String, double> totalIngredientes = {};

    for (var receta in listProvider.recipes) {
      for (var ing in receta['ingredientes']) {
        final nombre = ing['ingrediente'];
        final cantidad = ing['cantidad'].toDouble();
        totalIngredientes[nombre] = (totalIngredientes[nombre] ?? 0) + cantidad;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Printable List")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            totalIngredientes.isEmpty
                ? Center(
                  child: Text(
                    "No ingredients to print",
                    style: TextStyle(color: texto),
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ingredients",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: texto,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...totalIngredientes.entries.map(
                      (e) => Text(
                        "- ${e.value} ${e.key}",
                        style: TextStyle(color: texto),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
