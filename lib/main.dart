import 'package:bonappetit/pages/search_main_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import '/theme/theme_provider.dart';
import '/theme/theme.dart';
import 'pages/recipes_page.dart';
import 'pages/add_recipe_page.dart';
import 'pages/list_page.dart';
import 'pages/user_page.dart';

void main() => runApp(const AppWrapper());

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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
        'recipes': (context) => const RecipesPage(),
        'add': (context) => const AddRecipePage(),
        'lista': (context) => const ListPage(),
        'perfil': (context) => UserPage(),
        'search': (context) => const SearchMain(),
      },
    );
  }
}
