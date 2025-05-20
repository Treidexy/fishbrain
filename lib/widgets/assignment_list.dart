import 'package:fishbrain/widgets/add_assignment.dart';
import 'package:fishbrain/widgets/assignment_card.dart';
import 'package:fishbrain/backend.dart';
import 'package:fishbrain/main.dart';
import 'package:fishbrain/widgets/assignment_expansion.dart';
import 'package:flutter/material.dart';

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
