import 'package:get/get.dart';

class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  void addItem(CartItem item) {
    var index = cartItems.indexWhere((element) => element.name == item.name);
    if (index == -1) {
      cartItems.add(item);
    } else {
      cartItems[index].quantity += item.quantity;
      cartItems.refresh();
    }
  }

  void removeItem(CartItem item) {
    cartItems.remove(item);
  }

  void clearCart() {
    cartItems.clear();
  }

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
}

