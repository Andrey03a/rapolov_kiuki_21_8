import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/department.dart';

class NewStudentForm extends StatefulWidget {
  final Function(StudentProfile) onSave;
  final StudentProfile? studentToEdit;

  const NewStudentForm({
    super.key,
    required this.onSave,
    this.studentToEdit,
  });

  @override
  State<NewStudentForm> createState() => _NewStudentFormState();
}

class _NewStudentFormState extends State<NewStudentForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  Department? _selectedDepartment;
  Gender? _selectedGender;
  int _marks = 50;

  @override
  void initState() {
    super.initState();
    if (widget.studentToEdit != null) {
      _firstNameController.text = widget.studentToEdit!.firstName;
      _lastNameController.text = widget.studentToEdit!.lastName;
      _selectedDepartment = widget.studentToEdit!.specialization;
      _selectedGender = widget.studentToEdit!.identity;
      _marks = widget.studentToEdit!.marks;
    }
  }

  void _saveStudent() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _selectedDepartment == null ||
        _selectedGender == null) {
      return;
    }

    final newStudent = StudentProfile(
      id: widget.studentToEdit?.id ?? DateTime.now().toString(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      specialization: _selectedDepartment!,
      marks: _marks,
      identity: _selectedGender!,
    );

    widget.onSave(newStudent);
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
                  widget.studentToEdit == null
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
                  value: _selectedDepartment,
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
                    setState(() => _selectedDepartment = value);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Gender>(
                  value: _selectedGender,
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
                    setState(() => _selectedGender = value);
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
