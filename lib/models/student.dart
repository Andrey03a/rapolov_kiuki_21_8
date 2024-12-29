import 'department.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

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

  StudentProfile.withId(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.specialization,
      required this.identity,
      required this.marks});

  StudentProfile copyWith(firstName, lastName, department, gender, grade) {
    return StudentProfile.withId(
        id: id,
        firstName: firstName,
        lastName: lastName,
        specialization: department,
        identity: gender,
        marks: grade);
  }

  static Department getDepartmentById(String id) {
    return departmentList.firstWhere(
      (department) => department.id == id,
      orElse: () => departmentList.first,
    );
  }


  static String departmentToString(Department department) {
    return department.toString().split('.').last;
  }


  static Future<List<StudentProfile>> remoteGetList() async {
    final url = Uri.https(baseUrl, "$studentsPath.json");

    final response = await http.get(
      url,
    );

    if (response.statusCode >= 400) {
      throw Exception("Failed to retrieve the data");
    }

    if (response.body == "null") {
      return [];
    }

    final Map<String, dynamic> data = json.decode(response.body);
    final List<StudentProfile> loadedItems = [];
    for (final item in data.entries) {
      loadedItems.add(
        StudentProfile(
          id: item.key,
          firstName: item.value['first_name']!,
          lastName: item.value['last_name']!,
          specialization: getDepartmentById(item.value['department']!),
          identity: Gender.values.firstWhere((v) => v.toString() == item.value['gender']!),
          marks: item.value['grade']!,
        ),
      );
    }
    return loadedItems;
  }

  static Future<StudentProfile> remoteCreate(
    firstName,
    lastName,
    department,
    gender,
    grade,
  ) async {

    final url = Uri.https(baseUrl, "$studentsPath.json");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'first_name': firstName!,
          'last_name': lastName,
          'department': department.id,
          'gender': gender.toString(),
          'grade': grade,
        },
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception("Couldn't create a student");
    }

    final Map<String, dynamic> resData = json.decode(response.body);

    return StudentProfile(
        id: resData['name'],
        firstName: firstName,
        lastName: lastName,
        specialization: department,
        identity: gender,
        marks: grade);
  }

  static Future remoteDelete(studentId) async {
    final url = Uri.https(baseUrl, "$studentsPath/$studentId.json");

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      throw Exception("Couldn't delete a student");
    }
  }

  static Future<StudentProfile> remoteUpdate(
    studentId,
    firstName,
    lastName,
    department,
    gender,
    grade,
  ) async {
    final url = Uri.https(baseUrl, "$studentsPath/$studentId.json");

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'first_name': firstName!,
          'last_name': lastName,
          'department': department.id,
          'gender': gender.toString(),
          'grade': grade,
        },
      ),
    );

    if (response.statusCode >= 400) {
      throw Exception("Couldn't update a student");
    }

    return StudentProfile(
        id: studentId,
        firstName: firstName,
        lastName: lastName,
        specialization: department,
        identity: gender,
        marks: grade);
  }

  
}
