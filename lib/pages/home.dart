import 'package:fishbrain/backend.dart';
import 'package:fishbrain/widgets/assignment_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CoursePreview> courses = [];

  @override
  void initState() {
    super.initState();

    previewCourses().then((l) {
      setState(() {
        courses = l;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hello")),
      body: Column(
        children: [
          for (var course in courses)
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AssignmentList(gcId: course.id),
                  ),
                );
              },
              child: Text(course.title),
            ),
        ],
      ),
    );
  }
}
