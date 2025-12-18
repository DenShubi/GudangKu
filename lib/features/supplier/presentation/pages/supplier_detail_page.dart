import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_header.dart';
import 'supplier_edit_page.dart';

class SupplierDetailPage extends StatelessWidget {
  final String id;
  final String name;
  final String address;
  final String email;
  final String phone;
  final String contactPerson;
  final String notes;
  final String? imageUrl;

  const SupplierDetailPage({
    super.key,
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.contactPerson,
    required this.notes,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil inisial huruf pertama
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(
                title: "Supplier",
                showBackButton: true,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                      image: (imageUrl != null && imageUrl!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (imageUrl != null && imageUrl!.isNotEmpty)
                        ? null
                        : Center(
                            child: Text(
                              initial,
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                  ),
                  
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      "PT. $name",
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),

              // 3. Info Kontak (Mirip bagian "Detail :" di Product)
              const Text(
                "Contact Info :", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildDetailRow("Address", address), 
              _buildDetailRow("Email", email),
              _buildDetailRow("No Telp", phone),
              _buildDetailRow("Contact Person", contactPerson),
              const SizedBox(height: 20),
              const Text(
                "Note:", 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 10),
              Text(
                notes,
                style: const TextStyle(
                  fontSize: 20, 
                  height: 1.5, 
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
              
              const SizedBox(height: 80), 
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: SizedBox(
          width: 70,
          height: 70,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SupplierEditPage(
                    id: id,
                    currentName: name,
                    currentContactPerson: contactPerson,
                    currentPhone: phone,
                    currentAddress: address,
                    currentEmail: email,
                    currentNotes: notes,
                    currentImageUrl: imageUrl,
                  ),
                ),
              );
            },
            backgroundColor: AppColors.creamBackground,
            shape: const CircleBorder(),
            elevation: 0,
            child: const Icon(Icons.edit, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk Baris Detail (Label kiri, Value kanan)
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          SizedBox(
            width: 100, 
            child: Text(
              label, 
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          
          // Value Kanan (Expanded + Align Right)
          Expanded(
            child: Text(
              value, 
              style: const TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}