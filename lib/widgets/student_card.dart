import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentCard extends StatelessWidget {
  final StudentProfile profile;

  const StudentCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final cardColor = profile.identity == Gender.male
        ? Colors.lightBlueAccent.shade100
        : Colors.pinkAccent.shade100;

    final textColor = profile.identity == Gender.male
        ? Colors.blue.shade800
        : Colors.pink.shade800;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [Colors.white, cardColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              departmentIcons[profile.specialization],
              size: 28,
              color: textColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profile.firstName} ${profile.lastName}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Факультет: ${profile.specialization.name.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  '${profile.marks}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.star,
                  color: textColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
