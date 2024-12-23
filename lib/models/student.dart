import 'department.dart';

enum Gender { male, female }

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
