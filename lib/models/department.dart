import 'package:flutter/material.dart';

class Department {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  Department({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

final List<Department> departmentList = [
  Department(
    id: 'finance',
    name: 'Фінанси',
    icon: Icons.account_balance_wallet,
    color: Colors.greenAccent,
  ),
  Department(
    id: 'law',
    name: 'Юриспруденція',
    icon: Icons.balance,
    color: Colors.blueAccent,
  ),
  Department(
    id: 'it',
    name: 'ІТ',
    icon: Icons.code,
    color: Colors.limeAccent.shade700,
  ),
  Department(
    id: 'medical',
    name: 'Медицина',
    icon: Icons.health_and_safety,
    color: Colors.redAccent,
  ),
];
