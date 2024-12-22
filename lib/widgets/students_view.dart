import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_card.dart';

class StudentsView extends StatelessWidget {
  const StudentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<StudentProfile> studentProfiles = [
      StudentProfile(
        firstName: 'Олена',
        lastName: 'Коваль',
        specialization: Department.finance,
        marks: 85,
        identity: Gender.female,
      ),
      StudentProfile(
        firstName: 'Андрій',
        lastName: 'Петренко',
        specialization: Department.it,
        marks: 90,
        identity: Gender.male,
      ),
      StudentProfile(
        firstName: 'Іван',
        lastName: 'Сидоров',
        specialization: Department.law,
        marks: 78,
        identity: Gender.male,
      ),
      StudentProfile(
        firstName: 'Марія',
        lastName: 'Іванова',
        specialization: Department.medical,
        marks: 92,
        identity: Gender.female,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Список студентів',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.pinkAccent.shade100,
      ),
      body: ListView.builder(
        itemCount: studentProfiles.length,
        itemBuilder: (context, index) {
          return StudentCard(profile: studentProfiles[index]);
        },
      ),
    );
  }
}
