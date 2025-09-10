import 'dart:math';

import 'package:Retail_Application/core/utils/apz_mock_service.dart';
import 'package:Retail_Application/models/api_test/apz_product.dart';
import 'package:Retail_Application/data/repositories/apz_product.dart';

class ProductMockRepository implements ProductRepository {
  // --- Singleton Pattern ---
  ProductMockRepository._privateConstructor() {
    _init();
  }
  static final ProductMockRepository _instance = ProductMockRepository._privateConstructor();
  factory ProductMockRepository() {
    return _instance;
  }

  final MockService _mockService = MockService();
  final List<ApzProduct> _products = [];
  bool _isInitialized = false;

  Future<void> _init() async {
    if (!_isInitialized) {
      final data = await _mockService.loadMock("mock/products/get_products.json");
      final initialProducts = (data as List).map((json) => ApzProduct.fromJson(json)).toList();
      _products.addAll(initialProducts);
      _isInitialized = true;
    }
  }

  @override
  Future<List<ApzProduct>> getProducts() async {
    await _init(); // Ensure initialized
    // Return a copy to prevent external modification
    return Future.value(List<ApzProduct>.from(_products));
  }

  @override
  Future<ApzProduct> createProduct(ApzProduct product) async {
    await _init();
    final newProduct = ApzProduct(
      // Create a new product with a random ID
      id: Random().nextInt(1000) + 100, // Random ID > 100
      title: product.title,
      price: product.price,
      description: product.description,
      image: product.image,
      category: product.category,
    );
    _products.insert(0, newProduct);
    return Future.value(newProduct);
  }

  @override
  Future<ApzProduct> updateProduct(int id, ApzProduct product) async {
    await _init();
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      // Replace the old product with the new data
      _products[index] = ApzProduct(
        id: id, // Keep the original ID
        title: product.title,
        price: product.price,
        description: product.description,
        image: product.image,
        category: product.category,
      );
      return Future.value(_products[index]);
    } else {
      throw Exception("Product with ID $id not found in mock repository.");
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    await _init();
    final initialLength = _products.length;
    _products.removeWhere((p) => p.id == id);
    if (_products.length == initialLength) {
      throw Exception("Product with ID $id not found in mock repository.");
    }
    return Future.value();
  }
}
