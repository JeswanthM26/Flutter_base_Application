import 'package:Retail_Application/models/api_test/apz_product.dart';

abstract class ProductRepository {
  Future<List<ApzProduct>> getProducts();
  Future<ApzProduct> createProduct(ApzProduct product);
  Future<ApzProduct> updateProduct(int id, ApzProduct product);
  Future<void> deleteProduct(int id);
}
