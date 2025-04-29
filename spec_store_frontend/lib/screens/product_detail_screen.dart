import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import 'product_edit_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final product = productProvider.products.firstWhere(
      (prod) => prod.id == productId,
      orElse:
          () => Product(
            id: '',
            name: 'Product Not Found',
            description: 'No description available.',
            price: 0.0,
            imageUrl: '',
          ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      appBar: AppBar(
        title: Text(
          product.name,
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color(0xFF7C4DFF),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack,
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        product.imageUrl.isNotEmpty
                            ? Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (ctx, error, stackTrace) =>
                                      _buildPlaceholder(),
                            )
                            : _buildPlaceholder(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                product.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Price: ₹${product.price.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final updatedProduct = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProductScreen(product: product),
            ),
          );

          if (updatedProduct != null) {
            await Provider.of<ProductProvider>(
              context,
              listen: false,
            ).updateProduct(updatedProduct.id, updatedProduct);

            await Provider.of<ProductProvider>(
              context,
              listen: false,
            ).fetchProducts();
          }
        },
        label: const Text("Edit", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.edit, color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
      ),
    );
  }
}
