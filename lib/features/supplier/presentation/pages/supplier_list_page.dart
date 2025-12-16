import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_header.dart';
import '../widgets/supplier_card.dart';
import 'supplier_detail_page.dart';
import 'supplier_add_page.dart';
import '../providers/supplier_provider.dart';

class SupplierListPage extends StatefulWidget {
  const SupplierListPage({super.key});

  @override
  State<SupplierListPage> createState() => _SupplierListPageState();
}

class _SupplierListPageState extends State<SupplierListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<SupplierProvider>(
        context,
        listen: false,
      ).fetchSuppliers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const CustomHeader(title: "Supplier", showBackButton: false),

              const SizedBox(height: 20),

              // Consumer SupplierProvider
              Expanded(
                child: Consumer<SupplierProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.errorMessage != null) {
                      return Center(child: Text(provider.errorMessage!));
                    }
                    if (provider.suppliers.isEmpty) {
                      return const Center(child: Text("No suppliers yet."));
                    }
                    return ListView.builder(
                      itemCount: provider.suppliers.length,
                      itemBuilder: (context, index) {
                        final supplier = provider.suppliers[index];
                        return GestureDetector(
                          onLongPress: () {
                            _showDeleteDialog(
                              context,
                              'Delete Supplier',
                              'Are you sure you want to delete "${supplier.name}"?',
                              () async {
                                final success = await provider.deleteSupplier(supplier.id);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(success
                                          ? 'Supplier deleted successfully'
                                          : 'Failed to delete supplier'),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          child: SupplierCard(
                          name: supplier.name,
                          phone: supplier.phone,
                          address: supplier.address,
                          imageUrl: supplier.imageUrl, 
                          
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SupplierDetailPage(
                                  id: supplier.id,
                                  name: supplier.name,
                                  address: supplier.address,
                                  email: supplier.email,
                                  phone: supplier.phone,
                                  contactPerson: supplier.contactPerson,
                                  notes: supplier.notes,
                                  imageUrl: supplier.imageUrl,
                                ),
                              ),
                            );
                          },
                        ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 120, right: 10),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SupplierAddPage(),
                ),
              );
            },
            backgroundColor: AppColors.creamBackground,
            shape: const CircleBorder(),
            elevation: 4,
            child: const Icon(Icons.add, color: Colors.white, size: 40),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: onConfirm,
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}