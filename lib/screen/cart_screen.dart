import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_mobile_app/controller/cartcontroller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController _cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _cartController.clearCart();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_cartController.cartItems.isEmpty) {
          return const Center(
            child: Text('Your cart is empty'),
          );
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = _cartController.cartItems[index];
                    return ListTile(
                      leading: Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(item.name),
                      subtitle: Text('Price: \$${item.price}\nQuantity: ${item.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () {
                          _cartController.removeItem(item);
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${_cartController.totalPrice}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your pay now functionality here
                },
                child: const Text('Pay Now'),
              ),
            ],
          );
        }
      }),
    );
  }
}
