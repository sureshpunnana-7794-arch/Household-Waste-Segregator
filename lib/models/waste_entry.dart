import 'package:flutter/material.dart';

class WasteType {
  final int id;
  final String name;
  final String description;
  final String examples;
  final IconData icon;
  final Color color;
  final Color pale;

  const WasteType({
    required this.id,
    required this.name,
    required this.description,
    required this.examples,
    required this.icon,
    required this.color,
    required this.pale,
  });
}

const List<WasteType> kWasteTypes = [
  WasteType(
    id: 0,
    name: 'Wet waste',
    description: 'Biodegradable household waste',
    examples: 'Fruit peels, leftovers, tea leaves, vegetable scraps',
    icon: Icons.eco_rounded,
    color: Color(0xFF249568),
    pale: Color(0xFFE4F5EC),
  ),
  WasteType(
    id: 1,
    name: 'Dry waste',
    description: 'Reusable and recyclable materials',
    examples: 'Paper, cardboard, clean plastic bottles, containers',
    icon: Icons.inventory_2_rounded,
    color: Color(0xFF3986C8),
    pale: Color(0xFFE8F2FC),
  ),
  WasteType(
    id: 2,
    name: 'Metallic',
    description: 'Separate metal for specialized recycling',
    examples: 'Aluminium cans, tins, bottle caps, iron scraps',
    icon: Icons.hardware_rounded,
    color: Color(0xFFB78128),
    pale: Color(0xFFFBF2DF),
  ),
  WasteType(
    id: 3,
    name: 'Sanitary',
    description: 'Hygiene-related household waste',
    examples: 'Diapers, sanitary pads, medical swabs, tissues',
    icon: Icons.health_and_safety_rounded,
    color: Color(0xFF9870C5),
    pale: Color(0xFFF2EAF9),
  ),
];

class WasteEntry {
  final String id;
  final int type;
  final String item;
  final double quantity;
  final DateTime date;
  final String userId;

  WasteEntry({
    required this.id,
    required this.type,
    required this.item,
    required this.quantity,
    required this.date,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'item': item,
      'quantity': quantity,
      'date': date.toIso8601String(),
      'userId': userId,
    };
  }

  factory WasteEntry.fromMap(Map<String, dynamic> map, [String? docId]) {
    return WasteEntry(
      id: docId ?? map['id'] ?? '',
      type: (map['type'] as num?)?.toInt() ?? 0,
      item: map['item'] as String? ?? 'Unnamed item',
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0.0,
      date: map['date'] != null
          ? DateTime.tryParse(map['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      userId: map['userId'] as String? ?? 'guest',
    );
  }
}
