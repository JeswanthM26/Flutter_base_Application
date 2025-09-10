import 'package:Retail_Application/core/configs/apz_app_config.dart';
import 'package:Retail_Application/data/repositories/apz_product.dart';
import 'package:Retail_Application/models/api_test/apz_product.dart';
import 'package:flutter/material.dart';
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final ProductRepository _repository;
  bool _isLoading = false;
  String? _error;
  List<ApzProduct> _products = [];

  @override
  // void initState() {
  //   super.initState();
  //   _repository = AppConfig.isMock ? ProductMockRepository() : ProductApiRepository();
  //   _getProducts();
  // }

  // --- Data Fetching Methods ---
  // ignore: override_on_non_overriding_member
  Future<void> _getProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final products = await _repository.getProducts();
      setState(() => _products = products);
      _showSnackBar("Products loaded successfully!");
    } catch (e) {
      setState(() => _error = e.toString());
      _showSnackBar("Error loading products: $_error", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- CRUD Methods ---
  Future<void> _createProduct(ApzProduct product) async {
    setState(() => _isLoading = true);
    try {
      final createdProduct = await _repository.createProduct(product);
      setState(() => _products.insert(0, createdProduct));
      _showSnackBar("Product created with ID: ${createdProduct.id}!");
    } catch (e) {
      _showSnackBar("Error creating product: $e", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProduct(int id, ApzProduct product) async {
    setState(() => _isLoading = true);
    try {
      final updatedProduct = await _repository.updateProduct(id, product);
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        setState(() => _products[index] = updatedProduct);
      }
      _showSnackBar("Product $id updated!");
    } catch (e) {
      _showSnackBar("Error updating product: $e", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteProduct(int id) async {
    setState(() => _isLoading = true);
    try {
      await _repository.deleteProduct(id);
      setState(() => _products.removeWhere((p) => p.id == id));
      _showSnackBar("Product $id deleted!");
    } catch (e) {
      _showSnackBar("Error deleting product: $e", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- Dialogs and UI Helpers ---
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
    ));
  }


  void _showDeleteConfirmationDialog(ApzProduct product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product?"),
        content: Text("Are you sure you want to delete '${product.title}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteProduct(product.id!);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _showProductFormDialog({ApzProduct? product}) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: product?.title);
    final priceController = TextEditingController(text: product?.price.toString());
    final descriptionController = TextEditingController(text: product?.description);
    final isEditing = product != null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? "Edit Product" : "Create Product"),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                    validator: (value) => (value?.isEmpty ?? true) ? "Title is required" : null,
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: "Price"),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value?.isEmpty ?? true) return "Price is required";
                      if (double.tryParse(value!) == null) return "Enter a valid price";
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLines: 3,
                    validator: (value) => (value?.isEmpty ?? true) ? "Description is required" : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final productData = ApzProduct(
                    id: product?.id, // Keep original ID for updates
                    title: titleController.text,
                    price: double.parse(priceController.text),
                    description: descriptionController.text,
                    image: product?.image ?? "https://via.placeholder.com/150", // Use existing or default image
                    category: product?.category ?? "general", // Use existing or default category
                  );
                  if (isEditing) {
                    _updateProduct(product.id!, productData);
                  } else {
                    _createProduct(productData);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConfig.isMock ? "Products (Mock)" : "Products (API)"),
        actions: [
          if (_isLoading) const Center(child: CircularProgressIndicator(color: Colors.white)),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _getProducts),
        ],
      ),
      body: _error != null
          ? Center(child: Text("An error occurred: $_error"))
          : _products.isEmpty && !_isLoading
              ? const Center(child: Text("No products found. Add one!"))
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(product.image)),
                        title: Text(product.title),
                        subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showProductFormDialog(product: product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteConfirmationDialog(product),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
