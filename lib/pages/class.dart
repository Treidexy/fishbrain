import 'package:flutter/material.dart';

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
