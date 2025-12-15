import 'dart:io'; // [WAJIB]
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  Future<List<ProductModel>> getProducts() async {
    return await remoteDataSource.getProducts();
  }

  Future<void> addProduct(ProductModel product) async {
    return await remoteDataSource.addProduct(product);
  }
}