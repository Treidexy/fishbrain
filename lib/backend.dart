import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishbrain/main.dart' show AssignmentInfo;
import 'package:googleapis/classroom/v1.dart';
import 'package:googleapis/docs/v1.dart' hide List;
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:http/http.dart' as http;

late final AuthClient client;

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

  final classroomApi = ClassroomApi(client);

  final uid = user.uid;
  final userDoc = await FirebaseFirestore.instance.doc("users/$uid").get();
  final courseIds = userDoc.data()!['courses'];
  return <CoursePreview>[
    for (var id in courseIds)
      CoursePreview(id: id, title: (await classroomApi.courses.get(id)).name!),
  ];
}

Future<AuthClient> reqCred(List<String> scopes) async {
  final cred = await requestAccessCredentials(
    clientId:
        "21324585118-liplm5rq5174jaubqgmjkqbjshsjo02c.apps.googleusercontent.com",
    scopes: scopes,
  );
  return authenticatedClient(http.Client(), cred);
}

Future<void> authorizeSession() async {
  client = await reqCred([
    DriveApi.driveScope,
    ClassroomApi.classroomCourseworkStudentsScope,
    DocsApi.documentsScope,
  ]);
}

Future<List<AssignmentInfo>> getAssignments(String gcId) async {
  final classroomApi = ClassroomApi(client);
  final work = await classroomApi.courses.courseWork.list(gcId);
  return [
    for (var assignment in work.courseWork!)
      AssignmentInfo(
        title: assignment.title!,
        description: assignment.description,
      ),
  ];
}

Future<void> postAssignment(String gcId, AssignmentInfo info) async {
  final classroomApi = ClassroomApi(client);
  final request = CourseWork(
    title: info.title,
    description: info.description,
    dueDate: Date(
      day: info.dueDate?.day,
      month: info.dueDate?.month,
      year: info.dueDate?.year,
    ),
    dueTime: TimeOfDay(
      hours: info.dueDate?.hour,
      minutes: info.dueDate?.minute,
      seconds: info.dueDate?.second,
    ),
    workType: "ASSIGNMENT",
    state: "ACTIVE",
  );
  await classroomApi.courses.courseWork.create(request, gcId);
}
