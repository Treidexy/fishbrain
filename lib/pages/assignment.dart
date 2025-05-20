import 'package:flutter/material.dart';

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
