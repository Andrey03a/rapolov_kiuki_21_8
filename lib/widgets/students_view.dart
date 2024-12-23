import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_card.dart';
import 'new_student_form.dart';

class StudentsView extends StatefulWidget {
  const StudentsView({super.key});

  @override
  State<StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends State<StudentsView> {
  final List<StudentProfile> studentProfiles = [
    StudentProfile(
      id: '1',
      firstName: 'Олена',
      lastName: 'Коваль',
      specialization: Department.finance,
      marks: 85,
      identity: Gender.female,
    ),
    StudentProfile(
      id: '2',
      firstName: 'Андрій',
      lastName: 'Петренко',
      specialization: Department.it,
      marks: 90,
      identity: Gender.male,
    ),
  ];

  void _openStudentForm({StudentProfile? student, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => NewStudentForm(
        studentToEdit: student,
        onSave: (updatedStudent) {
          setState(() {
            if (index != null) {
              studentProfiles[index] = updatedStudent;
            } else {
              studentProfiles.add(updatedStudent);
            }
          });
        },
      ),
    );
  }

  void _deleteStudent(int index) {
    final removedStudent = studentProfiles[index];
    setState(() {
      studentProfiles.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${removedStudent.firstName} ${removedStudent.lastName} видалено',
        ),
        action: SnackBarAction(
          label: 'Відмінити',
          onPressed: () {
            setState(() {
              studentProfiles.insert(index, removedStudent);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Студенти',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.pinkAccent.shade100,
      ),
      body: studentProfiles.isEmpty
          ? const Center(
              child: Text(
                'Список порожній',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: studentProfiles.length,
              itemBuilder: (context, index) {
                final student = studentProfiles[index];
                return Dismissible(
                  key: ValueKey(student.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.delete, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Видалення...',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (_) => _deleteStudent(index),
                  child: InkWell(
                    onTap: () => _openStudentForm(student: student, index: index),
                    child: StudentCard(profile: student),
                  ),
                );
              },
            ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: const EdgeInsets.only(left: 16, bottom: 16),
          child: FloatingActionButton.extended(
            onPressed: () => _openStudentForm(),
            label: const Text(
              'Внести',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.pinkAccent.shade200,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}
