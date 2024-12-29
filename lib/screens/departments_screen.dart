import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/department.dart';
import '../providers/students_provider.dart';
import '../widgets/department_item.dart';

class DepartmentsScreen extends ConsumerWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentsProvider);

    if (state.inProcess) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Факультети'),
        backgroundColor: Colors.greenAccent.shade200,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: departmentList.length,
        itemBuilder: (context, index) {
          final department = departmentList[index];
          final studentCount = state.universityList
              .where((student) => student.specialization.id == department.id)
              .length;

          return DepartmentItem(department: department, studentCount: studentCount);
        },
      ),
    );
  }
}
