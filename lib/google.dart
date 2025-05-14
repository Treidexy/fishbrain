import 'package:googleapis/classroom/v1.dart';
import 'package:googleapis/docs/v1.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:http/http.dart' as http;

Future<void> google() async {
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
  final classroom = ClassroomApi(client);
  final courseId = "i aint telling u lil bro";
  final course = await classroom.courses.get(courseId);

  final drive = DriveApi(client);
  final docs = DocsApi(client);

  // final tf = course.teacherFolder!;
  // final l = await drive.files.list(driveId: tf.id);
  // final f = await drive.files.get(tf.id!) as File;
  final l = await drive.files.list(q: "'${tf.id!}' in parents");
  // print('l = ${l.files?.map((f) => f.toJson())}');
  final fid = l.files![1].id;

  final cw = await classroom.courses.courseWork.create(
    CourseWork(
      title: "Orthography/Phonetics",
      description:
          "Goal: Be able to pronounce any russian 'word' by spelling alone.\nTask: Write out the 'anglicized' spelling of a russian word.",
      workType: "ASSIGNMENT",
      state: "PUBLISHED",
      materials: [
        Material(
          driveFile: SharedDriveFile(
            driveFile: DriveFile(id: fid),
            shareMode: "STUDENT_COPY",
          ),
        ),
      ],
    ),
    courseId,
  );

  print('cw = ${cw.toJson()}');
}
