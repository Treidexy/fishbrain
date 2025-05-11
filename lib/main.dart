import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fish Face",
      theme: ThemeData.light(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          title: Row(
            children: [
              Text("Classroom"),
              Icon(Icons.chevron_right),
              Text("English"),
            ],
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.person))],
        ),
        body: Center(
          child: SizedBox(
            width: 750,
            child: Column(
              children: [
                SizedBox(height: 50),
                AssignmentItem(
                  "Theme Exploration Journal",
                  grade: 0,
                  maxGrade: 10,
                ),
                AssignmentItem(
                  "Thematic Web",
                  grade: 20,
                  maxGrade: 20,
                  dueDate: DateTime.parse("2025-06-02"),
                ),
                AssignmentExpansion(
                  AssignmentItem(
                    "Theme-Focused Analytical Paragraph",
                    maxGrade: 15,
                    dueDate: DateTime.parse("2025-05-12"),
                  ),
                  description:
                      "In small groups (3-4 students), you will create a visual \"thematic web\" for Macbeth. Choose one central theme that resonates strongly with the play (e.g., ambition). Then, brainstorm and connect at least five related ideas, characters, events, or symbols from the play that contribute to or illustrate this central theme. For each connection, include a brief explanation (1-2 sentences) of the relationship. You can use Google Drawings, Jamboard, or another collaborative visual tool.",
                ),
                AssignmentItem(
                  "\"What If?\" Thematic Extension",
                  maxGrade: 0,
                  dueDate: DateTime.parse("2025-05-08"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AssignmentItem extends StatelessWidget {
  final String title;
  final num? grade;
  final num maxGrade;
  final DateTime? dueDate;
  const AssignmentItem(
    this.title, {
    super.key,
    this.grade,
    required this.maxGrade,
    this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(5),
          ),
        ),
      ),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Row(children: [Icon(Icons.book), SizedBox(width: 5), Text(title)]),
          Row(
            children: [
              // Text("${grade ?? ''}/$maxGrade"),
              if (dueDate != null)
                Text(
                  DateFormat.MMMd().format(dueDate!),
                  style: TextStyle(
                    color:
                        dueDate!.isBefore(DateTime.now()) ? Colors.red : null,
                  ),
                ),
              // IconButton(onPressed: () {}, icon: Icon(Icons.link)),
            ],
          ),
        ],
      ),
    );
  }
}

class AssignmentExpansion extends StatelessWidget {
  final AssignmentItem item;
  final String description;
  const AssignmentExpansion(this.item, {super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Theme.of(context).colorScheme.primaryContainer),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          item,
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(color: Theme.of(context).colorScheme.surface),
              ],
            ),
            child: Text(description),
          ),
          TextButton(onPressed: () {}, child: Text("View")),
        ],
      ),
    );
  }
}
