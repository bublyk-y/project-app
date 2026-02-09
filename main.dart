import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class Product {
  final String id;
  final String name;
  final double price;
  final Color color;
  final String imagePath;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
    required this.imagePath,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const OnlineShop(),
    );
  }
}

class OnlineShop extends StatefulWidget {
  const OnlineShop({super.key});

  @override
  State<OnlineShop> createState() => _OnlineShopState();
}

class _OnlineShopState extends State<OnlineShop> {
  final List<Product> _products = [
    const Product
    (id: '1', name: 'Beanie', price: 25, color: Colors.black, imagePath: 'assets/images/beanie.webp'),
    const Product
    (id: '2', name: 'Oversize Hoodie', price: 60, color: Colors.redAccent, imagePath: 'assets/images/tshirt.webp'),
    const Product
    (id: '3', name: 'Logo T-Shirt', price: 30, color: Colors.black, imagePath: 'assets/images/hoodie.webp'),
    const Product
    (id: '4', name: 'Tote Bag', price: 10, color: Colors.redAccent, imagePath: 'assets/images/tote.webp'),
  ];

  final Set<String> _cartItemIds = {};

  void _toggleCartStatus(String productId) {
    setState(() {
      if (_cartItemIds.contains(productId)) {
        _cartItemIds.remove(productId);
      } else {
        _cartItemIds.add(productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merch StarStore'),
        actions: [
          CartCounterBadge(count: _cartItemIds.length),
          const SizedBox(width: 20),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          final isAdded = _cartItemIds.contains(product.id);

          return ProductCard(
            product: product,
            isInCart: isAdded,
            onCartPressed: () => _toggleCartStatus(product.id),
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isInCart;
  final VoidCallback onCartPressed;

  const ProductCard({
    super.key,
    required this.product,
    required this.isInCart,
    required this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: product.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                product.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, color: Colors.grey);
                },
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onCartPressed,
              style: IconButton.styleFrom(
                backgroundColor: isInCart ? Colors.green[100] : Colors.grey[100],
              ),
              icon: Icon(
                isInCart ? Icons.check : Icons.shopping_bag_outlined,
                color: isInCart ? Colors.green : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartCounterBadge extends StatelessWidget {
  final int count;

  const CartCounterBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.shopping_cart, size: 28),
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}