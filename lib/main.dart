import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fishbrain/firebase_options.dart';
import 'package:fishbrain/google.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final assignmentInfoness = [
  AssignmentInfo(title: "Theme Exploration Journal"),
  AssignmentInfo(title: "Thematic Web", dueDate: DateTime.parse("2025-06-02")),
  AssignmentInfo(
    title: "Theme-Focused Analytical Paragraph",
    dueDate: DateTime.parse("2025-05-12"),
    description:
        "In small groups (3-4 students), you will create a visual \"thematic web\" for Macbeth. Choose one central theme that resonates strongly with the play (e.g., ambition). Then, brainstorm and connect at least five related ideas, characters, events, or symbols from the play that contribute to or illustrate this central theme. For each connection, include a brief explanation (1-2 sentences) of the relationship. You can use Google Drawings, Jamboard, or another collaborative visual tool.",
  ),
  AssignmentInfo(
    title: "\"What If?\" Thematic Extension",
    dueDate: DateTime.parse("2025-05-08"),
  ),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
  await google();
  // runApp(const MainApp());
  await FirebaseAuth.instance.signOut();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fish Brain",
      theme: ThemeData.light(useMaterial3: true),
      home: ClassPage(body: AssignmentList(assignments: assignmentInfoness)),
    );
  }
}

class ClassPage extends StatelessWidget {
  final Widget body;
  const ClassPage({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      // body: Center(child: AssignmentPage(assignmentInfoness[2])),
      body: Center(child: Container(padding: EdgeInsets.all(15), child: body)),
    );
  }
}

class AssignmentPage extends StatelessWidget {
  final AssignmentInfo info;

  const AssignmentPage(this.info, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(info.title),
        actions: [ElevatedButton(onPressed: () {}, child: Text("Submit"))],
      ),

      body: Column(
        children: [
          Text(info.description ?? ""),
          Divider(height: 50),
          Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("last saved 8:37pm"),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ],
            ),
          ),
        ],
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
        onView: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) =>
                      ClassPage(body: AssignmentPage(widget.assignments[i])),
            ),
          );
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
    return SizedBox(
      width: 750,
      child: Column(
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
      ),
    );
  }
}

class AssignmentInfo {
  final String title;
  final DateTime? dueDate;
  final String? description;

  const AssignmentInfo({required this.title, this.dueDate, this.description});
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
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
  final void Function() onView;

  const AssignmentExpansion(
    this.info, {
    super.key,
    required this.onPressed,
    required this.onView,
  });

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
          TextButton(onPressed: onView, child: Text("View")),
        ],
      ),
    );
  }
}
