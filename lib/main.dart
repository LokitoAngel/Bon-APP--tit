import 'package:bonappetit/pages/recipes_by_category.dart';
import 'package:bonappetit/pages/search_main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/favorite_page.dart';
import 'pages/add_recipe_page.dart';
import 'pages/list_page.dart';
import 'pages/user_page.dart';
import 'pages/recipe_detail.dart';
import 'pages/print_list_page.dart';

import 'theme/theme_provider.dart';
import 'theme/theme.dart';
import 'providers/favorites_provider.dart';
import 'providers/list_provider.dart';

void main() => runApp(const AppWrapper());

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ListProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Recetario',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: 'home_page',
      routes: {
        'home_page': (context) => const HomePage(),
        'favorite_page': (context) => const FavoritePage(),
        'add': (context) => const AddRecipePage(),
        'lista': (context) => const ListPage(),
        'perfil': (context) => UserPage(),
        'recipe_detail': (context) => const RecipeDetailPage(),
        'print_list': (context) => const PrintListPage(),
        'recipes_by_category': (context) => const RecipesByCategoryPage(),
        'search': (context) => const SearchMain(),
      },
    );
  }
}
