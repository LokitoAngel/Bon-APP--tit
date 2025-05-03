import 'package:bonappetit/pages/widgets/SearchByName.dart';
import 'package:bonappetit/pages/widgets/search_by_ingredient.dart';
import 'package:flutter/material.dart';

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
              _buildTextButton("By ingredient", 1),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedButtonIndex,
              children: [ByName(), ByIngredient()],
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
