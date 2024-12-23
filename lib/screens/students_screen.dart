import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../providers/students_provider.dart';
import '../widgets/student_card.dart';
import '../widgets/new_student_form.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);

    void openStudentForm({StudentProfile? student, int? index}) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => NewStudentForm(
          studentToEdit: student,
          onSave: (updatedStudent) {
            final notifier = ref.read(studentsProvider.notifier);
            if (index != null) {
              notifier.updateStudent(index, updatedStudent);
            } else {
              notifier.addStudent(updatedStudent);
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Студенти'),
        backgroundColor: Colors.pinkAccent.shade100,
      ),
      body: students.isEmpty
          ? const Center(
              child: Text(
                'Список порожній',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
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
                  onDismissed: (_) {
                    ref.read(studentsProvider.notifier).removeStudent(index);
                    final container = ProviderScope.containerOf(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${student.firstName} ${student.lastName} видалено',
                        ),
                        action: SnackBarAction(
                          label: 'Відмінити',
                          onPressed: () {
                            container
                                .read(studentsProvider.notifier)
                                .undoRemove(student, index);
                          },
                        ),
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: () => openStudentForm(student: student, index: index),
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
            onPressed: () => openStudentForm(),
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
