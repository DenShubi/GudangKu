import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gudangku/features/product/data/datasources/product_remote_data_source.dart';
import 'package:gudangku/features/product/data/models/product_model.dart';


class ProductRepositoryImpl {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  Future<List<ProductModel>> getProducts() async {
    return await remoteDataSource.getProducts();
  }

  Future<void> addProduct(ProductModel product) async {
    return await remoteDataSource.addProduct(product);
  }

  /// Updates a product in the database, optionally uploading a new image.
  Future<void> updateProduct({
    required ProductModel product,
    File? newImageFile,
  }) async {
    final client = Supabase.instance.client;
    Map<String, dynamic> dataToUpdate = product.toJson();

    // 1. If there's a new image, upload it first
    if (newImageFile != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      const bucketName = 'product-images';

      await client.storage.from(bucketName).upload(fileName, newImageFile);
      final newImageUrl = client.storage.from(bucketName).getPublicUrl(fileName);
      dataToUpdate['image_url'] = newImageUrl;
    }

    // 2. Update the row in the products table
    await client
        .from('products')
        .update(dataToUpdate)
        .eq('id', product.id);
  }

  /// Alias kept for compatibility; delegates to updateProduct.
  Future<void> updateProductDirect({
    required ProductModel product,
    File? newImageFile,
  }) async {
    return updateProduct(product: product, newImageFile: newImageFile);
  }

  /// Deletes a product from the database.
  Future<void> deleteProduct(String id) async {
    final client = Supabase.instance.client;
    await client.from('products').delete().eq('id', id);
  }
}
