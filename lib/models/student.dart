import 'package:flutter/material.dart';

enum Department { finance, law, it, medical }
enum Gender { male, female }

const Map<Department, IconData> departmentIcons = {
  Department.finance: Icons.account_balance_wallet,
  Department.law: Icons.balance,
  Department.it: Icons.code,
  Department.medical: Icons.health_and_safety,
};

class StudentProfile {
  final String id;
  final String firstName;
  final String lastName;
  final Department specialization;
  final int marks;
  final Gender identity;

  StudentProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specialization,
    required this.marks,
    required this.identity,
  });
}
