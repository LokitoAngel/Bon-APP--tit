import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de ingredientes')),
      body: const Center(
        child: Text('Aquí se mostrarán los ingredientes combinados'),
      ),
    );
  }
}
