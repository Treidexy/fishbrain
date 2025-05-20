import 'package:fishbrain/widgets/assignment_card.dart';
import 'package:fishbrain/main.dart';
import 'package:flutter/material.dart';

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
