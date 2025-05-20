import 'package:fishbrain/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
