import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_mobile_app/controller/homescreencontroller.dart';
import 'package:ecommerce_mobile_app/controller/cartcontroller.dart';
import 'package:get/get.dart';
import 'navbar.dart';
import 'favorites_page.dart';
import 'profilescreen.dart';
import 'package:ecommerce_mobile_app/controller/favorites_controller.dart';
import 'package:ecommerce_mobile_app/screen/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  final String uri;

  const HomeScreen({Key? key, required this.uri}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final HomeScreenController _controller = HomeScreenController();
  final CartController _cartController = Get.put(CartController());
  final FavoriteController _favoritesController = Get.put(FavoriteController());
  late TextEditingController _searchController;
  List<dynamic> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    await _controller.fetchProducts();
    _filteredProducts = _controller.produits;
    setState(() {});
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _controller.produits
          .where((product) =>
              product['name'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterProducts,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _filterProducts(_searchController.text),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Hot Picks 🔥',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Text(
                  'See All',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  items: [
                    // Add your carousel items here
                    Image.network('https://example.com/image1.jpg'),
                    Image.network('https://example.com/image2.jpg'),
                    Image.network('https://example.com/image3.jpg'),
                  ],
                  options: CarouselOptions(
                    height: 200,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchProducts,
                    child: ListView.builder(
                      itemCount: _filteredProducts.isNotEmpty
                          ? _filteredProducts.length
                          : _controller.produits.length,
                      itemBuilder: (context, index) {
                        final produit = _filteredProducts.isNotEmpty
                            ? _filteredProducts[index]
                            : _controller.produits[index];
                        final name = produit['name'];
                        final smallDesc = produit['small_desc'];
                        final prix = double.tryParse(produit['prix'].toString()) ?? 0.0;
                        final qte = int.tryParse(produit['qte'].toString()) ?? 0;
                        final imageUrl = produit['image'] != null
                            ? 'http://127.0.0.1:8000/storage/${produit['image']}'
                            : null;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                if (imageUrl != null)
                                  Image.network(
                                    imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        smallDesc,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Price: \$${prix.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Quantity: $qte',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.favorite),
                                  onPressed: () {
                                    // Call function to add product to favorites
                                    _favoritesController.addFavorite(1, produit['id']);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_shopping_cart),
                                  onPressed: () {
                                    _cartController.addItem(CartItem(
                                      name: name,
                                      image: imageUrl ?? '',
                                      price: prix,
                                    ));
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const CartScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HOME PAGE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Get.to(() => ProfileScreen());
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Get.to(() => FavoritesPage());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Text('URI from login: ${widget.uri}'),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: MyBottomNavBar(onTabChange: navigateBottomBar),
    );
  }
}
