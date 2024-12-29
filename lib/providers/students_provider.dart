import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsState {
  final List<StudentProfile> universityList;
  final bool inProcess;
  final String? exception;

  StudentsState({
    required this.universityList,
    required this.inProcess,
    this.exception,
  });

  StudentsState copyWith({
    List<StudentProfile>? universityList,
    bool? inProcess,
    String? exception,
  }) {
    return StudentsState(
      universityList: universityList ?? this.universityList,
      inProcess: inProcess ?? this.inProcess,
      exception: exception ?? this.exception,
    );
  }
}

class StudentsNotifier extends StateNotifier<StudentsState> {
  StudentsNotifier() : super(StudentsState(universityList: [], inProcess: false));

  StudentProfile? _removedStudent;
  int? _removedIndex;

  Future<void> loaduniversityList() async {
    state = state.copyWith(inProcess: true, exception: null);
    try {
      final universityList = await StudentProfile.remoteGetList();
      state = state.copyWith(universityList: universityList, inProcess: false);
    } catch (e) {
      state = state.copyWith(
        inProcess: false,
        exception: e.toString(),
      );
    }
  }

  Future<void> addStudent(
    String firstName,
    String lastName,
    department,
    gender,
    int grade,
  ) async {
    try {
      state = state.copyWith(inProcess: true, exception: null);
      final student = await StudentProfile.remoteCreate(
          firstName, lastName, department, gender, grade);
      state = state.copyWith(
        universityList: [...state.universityList, student],
        inProcess: false,
      );
    } catch (e) {
      state = state.copyWith(
        inProcess: false,
        exception: e.toString(),
      );
    }
  }

  Future<void> editStudent(
    int index,
    String firstName,
    String lastName,
    department,
    gender,
    int grade,
  ) async {
    state = state.copyWith(inProcess: true, exception: null);
    try {
      final updatedStudent = await StudentProfile.remoteUpdate(
        state.universityList[index].id,
        firstName,
        lastName,
        department,
        gender,
        grade,
      );
      final updatedList = [...state.universityList];
      updatedList[index] = updatedStudent;
      state = state.copyWith(universityList: updatedList, inProcess: false);
    } catch (e) {
      state = state.copyWith(
        inProcess: false,
        exception: e.toString(),
      );
    }
  }

  void removeStudent(int index) {
    _removedStudent = state.universityList[index];
    _removedIndex = index;
    final updatedList = [...state.universityList];
    updatedList.removeAt(index);
    state = state.copyWith(universityList: updatedList);
  }

  void undoRemove() {
    if (_removedStudent != null && _removedIndex != null) {
      final updatedList = [...state.universityList];
      updatedList.insert(_removedIndex!, _removedStudent!);
      state = state.copyWith(universityList: updatedList);
    }
  }

  Future<void> eraseFromDb() async {
    state = state.copyWith(inProcess: true, exception: null);
    try {
      if (_removedStudent != null) {
        await StudentProfile.remoteDelete(_removedStudent!.id);
        _removedStudent = null;
        _removedIndex = null;
      }
      state = state.copyWith(inProcess: false);
    } catch (e) {
      state = state.copyWith(
        inProcess: false,
        exception: e.toString(),
      );
    }
  }
}

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, StudentsState>((ref) {
  final notif = StudentsNotifier();
  notif.loaduniversityList();
  return notif;
});
