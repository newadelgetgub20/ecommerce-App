import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreenController {
  List<dynamic> produits = [];

  get userName => null;

  Future<void> fetchProducts() async {
    const url = 'http://127.0.0.1:8000/api/produits';
    final uri = Uri.parse(url);
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        produits = json; // Assuming json is a list of products
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void fetchUserName() {}
}
