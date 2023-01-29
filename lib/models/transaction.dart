
// ignore_for_file: camel_case_types
import 'dart:io';

class transaction {
  final String name;
  final double price;
  int amount;
  final DateTime date;
  final File galleryImage;

  transaction({
    required this.name,
    required this.price,
    required this.amount,
    required this.date,
    required this.galleryImage,
  });
}
