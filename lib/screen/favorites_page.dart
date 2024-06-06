import 'package:flutter/material.dart';
import 'package:ecommerce_mobile_app/controller/favorites_controller.dart';
import 'package:get/get.dart';

class FavoritesPage extends StatelessWidget {
  final FavoriteController _favoritesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Obx(
        () => _favoritesController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : _favoritesController.favoriteItems.isEmpty
                ? const Center(child: Text('No favorite items yet.'))
                : ListView.builder(
                    itemCount: _favoritesController.favoriteItems.length,
                    itemBuilder: (context, index) {
                      final favoriteItem = _favoritesController.favoriteItems[index];
                      // Build your UI for each favorite item here
                      return ListTile(
                        title: Text(favoriteItem['name']),
                        subtitle: Text('Price: \$${favoriteItem['prix']}'),
                        // Add any additional information you want to display
                      );
                    },
                  ),
      ),
    );
  }
}
