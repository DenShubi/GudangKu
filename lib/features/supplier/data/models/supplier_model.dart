class SupplierModel {
  final String id;
  final String name;
  final String contactPerson;
  final String phone;
  final String address;
  final String notes;   // Konsisten menggunakan 'notes' sesuai Database
  final String? imageUrl; // [BARU] Field gambar

  SupplierModel({
    required this.id,
    required this.name,
    required this.contactPerson,
    required this.phone,
    required this.address,
    required this.notes,
    this.imageUrl, // [BARU]
  });

  // Dari Supabase (JSON) ke Dart
  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      // Mengubah ke String aman untuk ID (baik int maupun uuid)
      id: json['id']?.toString() ?? '', 
      name: json['name'] ?? '',
      
      // Pastikan key JSON ini SAMA PERSIS dengan nama kolom di Tabel Supabase
      contactPerson: json['contact_person'] ?? '', 
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      
      // Database: 'notes' -> Dart: 'notes'
      notes: json['notes'] ?? '', 
      
      // Database: 'image_url' -> Dart: 'imageUrl'
      imageUrl: json['image_url'], 
    );
  }

  // Dari Dart ke Supabase (Untuk keperluan update/insert jika pakai model)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact_person': contactPerson,
      'phone': phone,
      'address': address,
      'notes': notes,
      'image_url': imageUrl, // Sertakan ini juga
    };
  }
}