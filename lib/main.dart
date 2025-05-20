import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fishbrain/firebase_options.dart';
import 'package:fishbrain/backend.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
    await authorizeSession();
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fish Brain",
      theme: ThemeData.light(useMaterial3: true),
      home: HomePage(),
      // home: ClassPage(body: AssignmentList(gcId: "779557965768")),
    );
  }
}

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
  final String gcId;
  const AssignmentList({super.key, required this.gcId});

  @override
  State<StatefulWidget> createState() => _AssignmentListState();
}

class _AssignmentListState extends State<AssignmentList> {
  List<AssignmentInfo> assignments = [];
  int? expanded;

  @override
  void initState() {
    super.initState();

    getAssignments(widget.gcId).then((list) {
      setState(() {
        assignments = list;
      });
    });
  }

  Widget item(BuildContext context, int i) {
    if (i == expanded) {
      return AssignmentExpansion(
        assignments[i],
        onPressed: () {
          setState(() {
            expanded = null;
          });
        },
        onView: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => ClassPage(body: AssignmentPage(assignments[i])),
            ),
          );
        },
      );
    } else {
      return AssignmentCard(
        assignments[i],
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
          for (int i = 0; i < assignments.length; ++i)
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
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) =>
                        Dialog(child: AddAssignment(gcId: widget.gcId)),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class AddAssignment extends StatefulWidget {
  final String gcId;

  const AddAssignment({super.key, required this.gcId});

  @override
  State<StatefulWidget> createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
  DateTime? dueDate;
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

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
          Text("Title"),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(color: Theme.of(context).colorScheme.surface),
              ],
            ),
            child: TextField(controller: titleCtrl),
          ),
          Text("Description"),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(color: Theme.of(context).colorScheme.surface),
              ],
            ),
            child: TextField(
              controller: descCtrl,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          Text("Due Date"),
          TextButton(
            child: Text(
              dueDate == null ? "Not Set" : DateFormat.MMMd().format(dueDate!),
            ),
            onPressed: () {
              showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(9999),
              ).then(
                (date) => setState(() {
                  dueDate = date;
                }),
              );
            },
          ),
          TextButton(
            onPressed: () {
              final assignment = AssignmentInfo(
                title: titleCtrl.text,
                description: descCtrl.text,
                dueDate: dueDate,
              );
              postAssignment(widget.gcId, assignment);
              Navigator.pop(context);
            },
            child: Text("Post"),
          ),
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
