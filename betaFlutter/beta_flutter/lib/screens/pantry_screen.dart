import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../widgets/action_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/spoonacular_service.dart';

class DespensaScreen extends StatefulWidget {
  const DespensaScreen({super.key});

  @override
  State<DespensaScreen> createState() => _DespensaScreenState();
}

class _DespensaScreenState extends State<DespensaScreen> {
  bool isExpanded = false;
  List<Map<String, dynamic>> ingredientes = [];

  @override
  void initState() {
    super.initState();
    _cargarIngredientes();
  }

  void toggleFab() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  Future<void> _guardarIngredienteEnBackend(String name, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final url = Uri.parse('http://10.0.2.2:3000/ingredient');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'quantity': quantity,
        'userId': userId,
      }),
    );

    if (response.statusCode == 201) {
      print('Ingrediente guardado');
      _cargarIngredientes(); // refrescar
    } else {
      print('Error al guardar');
    }
  }

  Future<void> _cargarIngredientes() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    print('Flutter userId: $userId');
    final url = Uri.parse('http://10.0.2.2:3000/ingredient?userId=$userId');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        ingredientes = data.map((e) => {
              'name': e['name'],
              'quantity': e['quantity'],
            }).toList();
      });
    }
  }

  void _mostrarDialogoAgregarIngrediente() {
    String input = '';
    int cantidad = 1;
    List<String> sugerencias = [];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Ingrediente'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    onChanged: (value) async {
                      input = value;
                      if (value.length > 1) {
                        final results = await fetchIngredientSuggestions(value);
                        setState(() {
                          sugerencias = results;
                        });
                      }
                    },
                  ),
                  if (sugerencias.isNotEmpty)
                    ...sugerencias.map((s) => ListTile(
                          title: Text(s),
                          onTap: () {
                            input = s;
                            setState(() {
                              sugerencias = [];
                            });
                          },
                        )),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => cantidad = int.tryParse(val) ?? 1,
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Agregar'),
              onPressed: () {
                _guardarIngredienteEnBackend(input, cantidad);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Despensa"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: ingredientes
                .map((item) => ProductCard(
                      name: item['name'],
                      quantity: item['quantity'],
                    ))
                .toList(),
          ),
          if (isExpanded)
            Positioned(
              bottom: 100,
              right: MediaQuery.of(context).size.width / 2 - 75,
              child: Column(
                children: [
                  ActionButton(
                    text: "Ingresar texto",
                    onPressed: _mostrarDialogoAgregarIngrediente,
                  ),
                  const SizedBox(height: 16),
                  ActionButton(
                    text: "Fotografiar producto",
                    onPressed: () => debugPrint("Fotografiar producto"),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleFab,
        backgroundColor: const Color(0xFFC53415),
        child: Icon(isExpanded ? Icons.close : Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
        selectedItemColor: const Color(0xFFBA361A),
        unselectedItemColor: const Color(0xFFD3634B),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.filter_alt), label: 'Filter'),
        ],
      ),
    );
  }
}
