import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';
import '../widgets/student_card.dart';
import '../widgets/new_student_form.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentsProvider);

    if (state.inProcess) {
      return const Center(child: CircularProgressIndicator());
    }

    void openStudentForm({int? index}) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => NewStudentForm(studentIndex: index,),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.exception != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.exception!,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Студенти'),
        backgroundColor: Colors.pinkAccent.shade100,
      ),
      body: state.universityList.isEmpty
          ? const Center(
              child: Text(
                'Список порожній',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: state.universityList.length,
              itemBuilder: (context, index) {
                final student = state.universityList[index];
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
                                .undoRemove();
                          },
                        ),
                      ),
                    ).closed.then((value) {
                      if (value != SnackBarClosedReason.action) {
                        ref.read(studentsProvider.notifier).eraseFromDb();
                      }
                    });
                  },
                  child: GestureDetector(
                    onTap: () => openStudentForm(index: index),
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
