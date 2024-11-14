import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mydo/widgets/card_section.dart';
import 'package:mydo/widgets/task_card.dart';
import 'package:intl/intl.dart';

import '../classes/task.dart';
import '../data/constants.dart';
import '../persistence.dart';
import '../themes.dart';

class HistoricalList extends StatefulWidget {
  final Function superSetState;

  const HistoricalList({
    super.key,
    required this.superSetState,
  });

  @override
  State<HistoricalList> createState() => _HistoricalList();
}

class _HistoricalList extends State<HistoricalList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseHelper.instance.getHistoricalTasks(),
        builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: Text('Loading...'),);
          }

          var dateMap = groupBy(snapshot.data!, (Task task) => DateFormat.yMMMMd().format(task.date!));

          return ListView(
            children: [ for ( var date in dateMap.keys )
              CardSection(
                title: date,
                gradient: MydoGradients.dateSection,
                taskCards: [ for ( var task in dateMap[date]! )
                  TaskCard(
                    task: task,
                    showDeleteButton: true,
                    color: MydoColors.pastCard,
                    onTap: () {},
                    superSetState: widget.superSetState,
                    table: 'historical_tasks',
                  )
                ]
              )
            ],
          );
        }
    );
  }
}