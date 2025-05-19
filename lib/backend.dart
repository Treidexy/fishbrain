import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishbrain/main.dart' show AssignmentInfo;
import 'package:googleapis/classroom/v1.dart';
import 'package:googleapis/docs/v1.dart' hide List;
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:http/http.dart' as http;

late ClassroomApi classroomApi;
late DriveApi driveApi;
late DocsApi docsApi;

class CoursePreview {
  final String id;
  final String title;

  CoursePreview({required this.id, required this.title});
}

Future<List<CoursePreview>> previewCourses() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return [];
  }
  final uid = user.uid;
  final userDoc = await FirebaseFirestore.instance.doc("users/$uid").get();
  final courseIds = userDoc.data()!['courses'];
  return <CoursePreview>[
    for (var id in courseIds)
      CoursePreview(id: id, title: (await classroomApi.courses.get(id)).name!),
  ];
}

Future<void> authorizeSession() async {
  final cred = await requestAccessCredentials(
    clientId:
        "21324585118-liplm5rq5174jaubqgmjkqbjshsjo02c.apps.googleusercontent.com",
    scopes: [
      ClassroomApi.classroomCourseworkStudentsScope,
      DocsApi.documentsScope,
      DriveApi.driveScope,
    ],
  );
  final client = authenticatedClient(http.Client(), cred);
  classroomApi = ClassroomApi(client);
  driveApi = DriveApi(client);
  docsApi = DocsApi(client);
}

Future<List<AssignmentInfo>> getAssignments(gcId) async {
  final work = await classroomApi.courses.courseWork.list(gcId);
  print(work.courseWork![0].dueDate);
  return [
    for (var assignment in work.courseWork!)
      AssignmentInfo(
        title: assignment.title!,
        description: assignment.description,
      ),
  ];
}
