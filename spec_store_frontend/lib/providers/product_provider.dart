import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => [..._products];

  final String _baseUrl =
      'http://localhost:5000/api/products'; // Replace with your backend URL if needed

  // Fetch All Products
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _products = data.map((item) => Product.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Add Product
  Future<void> addProduct(Product product) async {
    try {
      print("the incoming product: ${product.toJson()}");
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      print(response.body);
      if (response.statusCode == 201) {
        final newProduct = Product.fromJson(json.decode(response.body));
        _products.add(newProduct);
        notifyListeners();
      }
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  // Update Product
  Future<void> updateProduct(String id, Product updatedProduct) async {
    try {
      final url = '$_baseUrl/$id';
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedProduct.toJson()),
      );
      if (response.statusCode == 200) {
        final index = _products.indexWhere((prod) => prod.id == id);
        if (index >= 0) {
          _products[index] = updatedProduct;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  // Delete Product
  Future<void> deleteProduct(String id) async {
    try {
      final url = '$_baseUrl/$id';
      final response = await http.delete(Uri.parse(url));
      if (response.statusCode == 200) {
        _products.removeWhere((prod) => prod.id == id);
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  // Get a product by ID (Optional for details view)
  Product? findById(String id) {
    return _products.firstWhere(
      (prod) => prod.id == id,
      orElse:
          () => Product(
            id: '',
            name: '',
            description: '',
            price: 0,
            imageUrl: '',
          ),
    );
  }
}
