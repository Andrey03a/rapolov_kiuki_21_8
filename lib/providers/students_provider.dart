import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsNotifier extends StateNotifier<List<StudentProfile>> {
  StudentsNotifier() : super([]);

  void addStudent(StudentProfile student) {
    state = [...state, student];
  }

  void updateStudent(int index, StudentProfile updatedStudent) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) updatedStudent else state[i]
    ];
  }

  void removeStudent(int index) {
    final student = state[index];
    state = [...state]..removeAt(index);

    Future.delayed(const Duration(seconds: 5), () {
      if (!state.contains(student)) {
        state = state;
      }
    });
  }

  void undoRemove(StudentProfile student, int index) {
    state = [...state]..insert(index, student);
  }
}

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, List<StudentProfile>>(
  (ref) => StudentsNotifier(),
);
