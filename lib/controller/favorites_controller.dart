import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoriteController extends GetxController {
  var isLoading = false.obs;
  var favoriteItems = <dynamic>[].obs;

  @override
  void onInit() {
    fetchFavorites(1); // Provide a default user ID for initialization or adjust as needed
    super.onInit();
  }

  Future<void> fetchFavorites(int userId) async {
    isLoading(true);
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/favorite/$userId'));
    if (response.statusCode == 200) {
      favoriteItems.value = json.decode(response.body)['produit'];
    } else {
      // Handle error
    }
    isLoading(false);
  }

 Future<void> addFavorite(int userId, int productId) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/favorite/add'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'user_id': userId, 'produit_id': productId}),
  );
  if (response.statusCode == 201) {
    fetchFavorites(userId); // Refresh favorites after addition
  } else {
    // Handle error
    // For example:
    print('Failed to add favorite: ${response.statusCode}');
    // You can display an error message to the user or log the error
  }
}


  Future<void> removeFavorite(int userId, int productId) async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/favorite/delete/$productId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'user_id': userId}),
    );
    if (response.statusCode == 200) {
      fetchFavorites(userId);
    } else {
      // Handle error
    }
  }

  bool isFavorite(int productId) {
    return favoriteItems.any((item) => item['id'] == productId);
  }
}
