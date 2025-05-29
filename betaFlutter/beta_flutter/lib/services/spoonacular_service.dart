import 'dart:convert';
import 'package:http/http.dart' as http;

const String spoonacularKey = '071244a2b882444096f8c3012ca1bc05';
const String spoonacularURL = 'https://api.spoonacular.com/food/ingredients/autocomplete';

Future<List<String>> fetchIngredientSuggestions(String query) async {
  final response = await http.get(
    Uri.parse('$spoonacularURL?query=$query&number=5&apiKey=$spoonacularKey'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return List<String>.from(data.map((item) => item['name']));
  } else {
    throw Exception('Error obteniendo sugerencias');
  }
}
