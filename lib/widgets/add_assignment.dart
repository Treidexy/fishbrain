import 'package:fishbrain/backend.dart';
import 'package:fishbrain/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
