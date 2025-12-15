import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final String hexColor; 

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.hexColor,
  });

  // Helper: Mengubah String Hex menjadi Object Color
  Color get color {
    try {
      return Color(int.parse(hexColor));
    } catch (e) {
      return const Color(0xFFE5E5E5); // Default abu-abu jika error
    }
  }

  // Dari Supabase (JSON) ke Dart
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] ?? true, // Perhatikan snake_case DB
      hexColor: json['hex_color'] ?? '0xFFE5E5E5',
    );
  }

  // Dari Dart ke Supabase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'is_active': isActive,
      'hex_color': hexColor,
    };
  }
}