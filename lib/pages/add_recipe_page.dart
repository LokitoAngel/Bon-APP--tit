import 'package:flutter/material.dart';

class AddRecipePage extends StatelessWidget {
  const AddRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar receta')),
      body: const Center(
        child: Text('Esta es la página para agregar una receta'),
      ),
    );
  }
}
