import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';

class NewStudentForm extends ConsumerStatefulWidget {
  const NewStudentForm({
    super.key,
    this.studentIndex
  });

  final int? studentIndex;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewStudentFormState();
}
class _NewStudentFormState extends ConsumerState<NewStudentForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  Department? _selectedSpecialization;
  Gender? _selectedIdentity;
  int _marks = 50;

  @override
  void initState() {
    super.initState();
    if (widget.studentIndex != null) {
      final student = ref.read(studentsProvider).universityList[widget.studentIndex!];
      _firstNameController.text = student.firstName;
      _lastNameController.text = student.lastName;
      _selectedIdentity = student.identity;
      _selectedSpecialization = student.specialization;
      _marks = student.marks;
    }
  }

  void _saveStudent() async {
    if (widget.studentIndex == null)  {
      await ref.read(studentsProvider.notifier).addStudent(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedSpecialization,
            _selectedIdentity,
            _marks,
          );
    } else {
      await ref.read(studentsProvider.notifier).editStudent(
            widget.studentIndex!,
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _selectedSpecialization,
            _selectedIdentity,
            _marks,
          );
    }

    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.pink.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.studentIndex == null
                      ? 'Додати Студента'
                      : 'Редагувати Студента',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Ім’я',
                    labelStyle: TextStyle(color: Colors.blue.shade700),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade700),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Прізвище',
                    labelStyle: TextStyle(color: Colors.pink.shade700),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink.shade700),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Department>(
                  value: _selectedSpecialization,
                  decoration: InputDecoration(
                    labelText: 'Факультет',
                    labelStyle: TextStyle(color: Colors.blue.shade700),
                    border: const OutlineInputBorder(),
                  ),
                  items: departmentList.map((department) {
                    return DropdownMenuItem(
                      value: department,
                      child: Row(
                        children: [
                          Icon(
                            department.icon,
                            color: department.color,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            department.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedSpecialization = value);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Gender>(
                  value: _selectedIdentity,
                  decoration: InputDecoration(
                    labelText: 'Стать',
                    labelStyle: TextStyle(color: Colors.pink.shade700),
                    border: const OutlineInputBorder(),
                  ),
                  items: Gender.values.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(
                        gender.toString().split('.').last,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedIdentity = value);
                  },
                ),
                const SizedBox(height: 16),
                Slider(
                  value: _marks.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: 'Оцінка: $_marks',
                  activeColor: Colors.pinkAccent,
                  inactiveColor: Colors.blueAccent.shade100,
                  onChanged: (value) {
                    setState(() => _marks = value.toInt());
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveStudent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade200,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.blueAccent.shade100,
                    elevation: 5,
                  ),
                  child: const Text(
                    'Зберегти',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
