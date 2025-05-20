import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fishbrain/widgets/assignment_list.dart';
import 'package:fishbrain/firebase_options.dart';
import 'package:fishbrain/backend.dart';
import 'package:flutter/material.dart';

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

class AssignmentInfo {
  final String title;
  final DateTime? dueDate;
  final String? description;

  const AssignmentInfo({required this.title, this.dueDate, this.description});
}
