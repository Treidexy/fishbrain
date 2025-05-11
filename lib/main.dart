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
        body: Column(
          children: [
            SizedBox(height: 50),
            Center(
              child: SizedBox(
                width: 750,
                child: AssignmentList(
                  assignments: [
                    AssignmentInfo(
                      title: "Theme Exploration Journal",
                      grade: 0,
                      maxGrade: 10,
                    ),
                    AssignmentInfo(
                      title: "Thematic Web",
                      grade: 20,
                      maxGrade: 20,
                      dueDate: DateTime.parse("2025-06-02"),
                    ),
                    AssignmentInfo(
                      title: "Theme-Focused Analytical Paragraph",
                      maxGrade: 15,
                      dueDate: DateTime.parse("2025-05-12"),
                      description:
                          "In small groups (3-4 students), you will create a visual \"thematic web\" for Macbeth. Choose one central theme that resonates strongly with the play (e.g., ambition). Then, brainstorm and connect at least five related ideas, characters, events, or symbols from the play that contribute to or illustrate this central theme. For each connection, include a brief explanation (1-2 sentences) of the relationship. You can use Google Drawings, Jamboard, or another collaborative visual tool.",
                    ),
                    AssignmentInfo(
                      title: "\"What If?\" Thematic Extension",
                      maxGrade: 0,
                      dueDate: DateTime.parse("2025-05-08"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AssignmentList extends StatefulWidget {
  final List<AssignmentInfo> assignments;
  const AssignmentList({super.key, required this.assignments});

  @override
  State<StatefulWidget> createState() => _AssignmentListState();
}

class _AssignmentListState extends State<AssignmentList> {
  int? expanded;

  Widget item(BuildContext context, int i) {
    if (i == expanded) {
      return AssignmentExpansion(
        widget.assignments[i],
        onPressed: () {
          setState(() {
            expanded = null;
          });
        },
      );
    } else {
      return AssignmentCard(
        widget.assignments[i],
        onPressed: () {
          setState(() {
            expanded = i;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < widget.assignments.length; ++i)
          // AnimatedSwitcher(
          //   transitionBuilder: (child, animation) {
          //     return SizeTransition(
          //       axisAlignment: -1,
          //       sizeFactor: animation,
          //       child: child,
          //     );
          //   },
          //   duration: Duration(milliseconds: 500),
          //   child: item(context, i),
          // ),
          item(context, i),
      ],
    );
  }
}

class AssignmentInfo {
  final String title;
  final DateTime? dueDate;
  final num? grade;
  final num maxGrade;
  final String? description;

  AssignmentInfo({
    required this.title,
    this.dueDate,
    this.grade,
    required this.maxGrade,
    this.description,
  });
}

class AssignmentCard extends StatelessWidget {
  final AssignmentInfo info;
  final void Function() onPressed;

  const AssignmentCard(this.info, {super.key, required this.onPressed});

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
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Row(
            children: [Icon(Icons.book), SizedBox(width: 5), Text(info.title)],
          ),
          Row(
            children: [
              // Text("${info.grade ?? ''}/$info.maxGrade"),
              if (info.dueDate != null)
                Text(
                  DateFormat.MMMd().format(info.dueDate!),
                  style: TextStyle(
                    color:
                        info.dueDate!.isBefore(DateTime.now())
                            ? Colors.red
                            : null,
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
  final AssignmentInfo info;
  final void Function() onPressed;

  const AssignmentExpansion(this.info, {super.key, required this.onPressed});

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
          AssignmentCard(info, onPressed: onPressed),
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
            child: Text(info.description ?? ""),
          ),
          TextButton(onPressed: () {}, child: Text("View")),
        ],
      ),
    );
  }
}
