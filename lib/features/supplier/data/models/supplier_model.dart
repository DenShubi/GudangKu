class SupplierModel {
  final String id;
  final String name;
  final String contactPerson;
  final String phone;
  final String address;
  final String notes;

  SupplierModel({
    required this.id,
    required this.name,
    required this.contactPerson,
    required this.phone,
    required this.address,
    required this.notes,
  });

  // Dari Supabase (JSON) ke Dart
  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      contactPerson: json['contact_person'] ?? '', // Pastikan sesuai nama kolom di Supabase
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  // Dari Dart ke Supabase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact_person': contactPerson,
      'phone': phone,
      'address': address,
      'notes': notes,
    };
  }
}