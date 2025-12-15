import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_header.dart';

class SupplierDetailPage extends StatelessWidget {
  final String name;
  final String address;
  final String email;
  final String phone;
  final String contactPerson;
  final String notes;

  const SupplierDetailPage({
    super.key,
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.contactPerson,
    required this.notes,
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
                showBackButton: false,
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
                    ),
                    child: Center(
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
                      name,
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
                "Info Kontak :", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildDetailRow("Alamat", address), 
              _buildDetailRow("Email", email),
              _buildDetailRow("No Telp", phone),
              _buildDetailRow("Nama CP", contactPerson),
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
              
              const SizedBox(height: 80), // Space bawah agar tidak ketutup FAB
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColors.creamBackground,
          shape: const CircleBorder(),
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 40),
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
        crossAxisAlignment: CrossAxisAlignment.start, // Align start agar jika alamat panjang tetap rapi
        children: [
          // Label Kiri (fixed width agar rapi jika label pendek)
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
              // overflow: TextOverflow.ellipsis, // Boleh di-uncomment jika ingin dipotong
            ),
          ),
        ],
      ),
    );
  }
}