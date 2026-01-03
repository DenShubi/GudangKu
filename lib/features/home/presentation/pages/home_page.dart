import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/providers/profile_provider.dart';
import '../../../product/presentation/providers/product_provider.dart';
import '../../../product/presentation/widgets/product_card.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../../../../core/utils/currency_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  String _username = "User";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getUserData();
    Future.microtask(() =>
        Provider.of<ProductProvider>(context, listen: false).fetchProducts());
  }

  void _getUserData() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null && user.email != null) {
      setState(() {
        _username = user.email!.split('@')[0];
        _username = _username[0].toUpperCase() + _username.substring(1);
      });
      
      // Fetch profile for avatar
      Provider.of<ProfileProvider>(context, listen: false)
          .fetchProfile(user.id, user.email!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Consumer<ProfileProvider>(
                    builder: (context, profileProvider, _) {
                      final avatarUrl = profileProvider.avatarUrl;
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                          image: avatarUrl != null && avatarUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(avatarUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: avatarUrl == null || avatarUrl.isEmpty
                            ? Center(
                                child: Text(
                                  _username.isNotEmpty ? _username[0].toUpperCase() : 'U',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            : null,
                      );
                    },
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hello",
                        style: const TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                      Text(
                        _username,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Consumer<ProductProvider>(
                builder: (context, provider, _) {
                  // Optimized: Use fold instead of manual loop
                  final currentStock = provider.products.fold<int>(
                    0,
                    (sum, product) => sum + product.stock,
                  );

                  const stockOut = 50;
                  final totalCalculated = currentStock + stockOut;

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEACDA3),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today, ${DateFormat('d MMMM yyyy').format(DateTime.now())}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryItem(totalCalculated.toString(), "Total"),
                            ),
                            
                            Container(width: 1, height: 40, color: Colors.black54),
                            
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: _buildSummaryItem(currentStock.toString(), "Stock In"),
                              ),
                            ),
                            
                            Container(width: 1, height: 40, color: Colors.black54),
                            
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: _buildSummaryItem(stockOut.toString(), "Stock Out"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

              const Text(
                "Items",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              Consumer<ProductProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.products.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Text("Tidak ada item."),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];
                      return ProductCard(
                        id: product.id.length > 8 ? product.id.substring(0, 8) : product.id,
                        name: product.name,
                        price: formatRupiah(product.price),
                        stock: product.stock,
                        category: product.categoryName ?? '-',
                        imageUrl: product.imageUrl,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                id: product.id,
                                name: product.name,
                                price: formatRupiah(product.price),
                                stock: "${product.stock}",
                                categoryId: product.categoryId,
                                categoryName: product.categoryName,
                                supplierId: product.supplierId,
                                supplierName: product.supplierName,
                                description: product.description,
                                imageUrl: product.imageUrl,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
