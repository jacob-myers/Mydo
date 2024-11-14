import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mydo/widgets/card_section.dart';
import 'package:mydo/widgets/task_card.dart';
import 'package:intl/intl.dart';
import 'package:mydo/widgets/task_editor.dart';
import 'package:mydo/classes/date_helpers.dart';

import '../classes/task.dart';
import '../data/constants.dart';
import '../persistence.dart';
import '../themes.dart';

class PlannedList extends StatefulWidget {
  final Function superSetState;

  const PlannedList({
    super.key,
    required this.superSetState,
  });

  @override
  State<PlannedList> createState() => _PlannedList();
}

class _PlannedList extends State<PlannedList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseHelper.instance.getPlannedTasks(),
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: Text('Loading...'),);
          }

          var dateMap = groupBy(snapshot.data!, (Task task) => DateFormat.yMMMMd().format(task.date!));
          var today = DateFormat.yMMMMd().format(DateTime.now());

          return ListView(
            children: [ for ( var date in dateMap.keys )
              CardSection(
                  title: date,
                  gradient: date == today ? MydoGradients.todaySection : MydoGradients.soonSection,
                  taskCards: [ for ( var task in dateMap[date]! )
                    TaskCard(
                      task: task,
                      showDeleteButton: true,
                      color: date == today ? MydoColors.timedTodayCard : MydoColors.soonCard,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return TaskEditor(
                              task: task,
                              onSubmit: () {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                            );
                          }
                        );
                      },
                      superSetState: widget.superSetState,
                    )
                  ]
              )
            ],
          );
        }
    );
  }
}