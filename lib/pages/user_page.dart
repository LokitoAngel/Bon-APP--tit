import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Map<String, dynamic> usuario = {
    'nombre': '',
    'foto': '',
    'telefono': '',
    'email': '',
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/Users.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      setState(() {
        usuario = {
          'nombre': jsonData['usuario']['nombre'],
          'foto': jsonData['usuario']['foto'],
          'telefono': jsonData['usuario']['telefono'],
          'email': jsonData['usuario']['email'],
        };
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar datos del usuario: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fondo = Theme.of(context).scaffoldBackgroundColor;
    final texto = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final primario = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: fondo,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: primario,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepOrangeAccent,
                ),
              )
              : Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white70,
                    ),
                    margin: const EdgeInsets.all(15),
                    height: 150,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              usuario['foto']!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.person, size: 60),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                usuario["nombre"]!,
                                style: const TextStyle(fontSize: 25),
                              ),
                              TextButton(
                                child: const Text(
                                  'View details',
                                  style: TextStyle(color: Colors.orangeAccent),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, "perfil");
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Secundarias(ruta: "perfil", texto: "Permissions"),
                  const Secundarias(ruta: "perfil", texto: "Settings"),
                  const Secundarias(ruta: "perfil", texto: "Term of services"),
                ],
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        backgroundColor: fondo,
        selectedItemColor: primario,
        unselectedItemColor: texto.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
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
              break;
          }
        },
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
}

class Secundarias extends StatelessWidget {
  const Secundarias({super.key, required this.texto, required this.ruta});

  final String texto;
  final String ruta;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white70,
      ),
      margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(texto, style: const TextStyle(fontSize: 18)),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, ruta),
            icon: const Icon(Icons.arrow_forward_ios, size: 18),
          ),
        ],
      ),
    );
  }
}
