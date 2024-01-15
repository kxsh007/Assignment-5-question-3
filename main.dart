import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductListScreen(),
        routes: {
          CartScreen.routeName: (context) => CartScreen(),
        },
      ),
    );
  }
}

class Product {
  final String image;
  final String name;
  final double price;

  Product({required this.image, required this.name, required this.price});
}

class CartProvider extends ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + item.price);
  }

  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

class ProductListScreen extends StatelessWidget {
  final List<Product> productList = [
    Product(
        image: 'assets/product 1.jpg', name: 'Apple Iphone 15', price: 150000),
    Product(image: 'assets/product 2.jpg', name: 'Oneplus 11R', price: 70000),
    Product(
        image: 'assets/product 3.jpg',
        name: 'Samsung Galaxy S23 Ultra',
        price: 124000),
    Product(
        image: 'assets/product 4.jpg', name: 'Oneplus Nord 3', price: 30000),
    Product(image: 'assets/product 5.jpg', name: 'Oneplus 7R', price: 40000),
    Product(image: 'assets/product 6.jpg', name: 'Vivo V29', price: 30000),
    Product(image: 'assets/product 7.jpg', name: 'Vivo V7', price: 25000),
    Product(image: 'assets/product 8.jpg', name: 'Vivo V9', price: 35000),
    Product(image: 'assets/product 9.jpg', name: 'Oppo A7', price: 20000),
    Product(image: 'assets/product 10.jpg', name: 'Oppo Reno 3', price: 40000),
    Product(image: 'assets/product 11.jpg', name: 'Oppo A17', price: 32000),
    Product(image: 'assets/product 12.jpg', name: 'Oppo Reno 3', price: 45000),
    Product(image: 'assets/product 13.jpg', name: 'Realme 11i', price: 33000),
    Product(
        image: 'assets/product 14.jpg', name: 'Redmi Note 11', price: 50000),
    Product(image: 'assets/product 15.jpg', name: 'Iqoo Neo 7', price: 28000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Phones'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          Product product = productList[index];
          return ListTile(
            leading: Image.asset(product.image),
            title: Text(product.name),
            subtitle:
                Text('₹${product.price.toStringAsFixed(2)}'), // Updated line
            trailing: Consumer<CartProvider>(
              builder: (context, cart, child) {
                bool isInCart = cart.cartItems.contains(product);
                return IconButton(
                  icon: isInCart
                      ? Icon(Icons.check)
                      : Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    if (isInCart) {
                      cart.removeFromCart(product);
                    } else {
                      cart.addToCart(product);
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: cartProvider.cartItems.length,
        itemBuilder: (context, index) {
          var product = cartProvider.cartItems[index];
          return ListTile(
            leading: Image.asset(product.image),
            title: Text(product.name),
            subtitle: Text('₹${product.price.toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: Icon(Icons.remove_shopping_cart),
              onPressed: () {
                cartProvider.removeFromCart(product);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                'Total: ₹${cartProvider.totalPrice.toStringAsFixed(2)}'), // Updated line
            ElevatedButton(
              onPressed: () {
                cartProvider.clearCart();
              },
              child: Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}
