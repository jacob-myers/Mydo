import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:mydo/classes/date_helpers.dart';
import 'package:mydo/widgets/card_section.dart';
import 'package:mydo/widgets/task_card.dart';
import 'package:mydo/widgets/task_editor.dart';
import 'package:mydo/classes/task.dart';
import 'package:mydo/data/constants.dart';
import 'package:mydo/persistence.dart';
import 'package:mydo/themes.dart';

class HomeList extends StatefulWidget {
  final Function superSetState;

  const HomeList({
    super.key,
    required this.superSetState,
  });

  @override
  State<HomeList> createState() => _HomeList();
}

class _HomeList extends State<HomeList> {

  void openTaskEditor(Task task) {
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
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.instance.getTasks(),
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {

        if (!snapshot.hasData) {
          return const Center(child: Text('Loading...'),);
        }

        var categoryMap = groupBy(snapshot.data!, (Task task) => task.category);

        //Deepcopy stuff: https://medium.com/@chetan.akarte/what-is-the-recommended-way-to-clone-a-dart-list-map-and-set-4dcbe65fe2b7
        var incomplete = categoryMap[PLANNED_TAG]?.toList() ?? [];
        incomplete.removeWhere((e) => e.date == null || e.date!.isAfter(DateTime.now()));
        print(incomplete);

        categoryMap[PLANNED_TAG]?.removeWhere((e) => e.date != null && (e.date!.isBefore(DateTime.now()) || !e.date!.isToday));

        print(incomplete);

        return ListView(
          children: [
            incomplete == null || incomplete.isEmpty ? Container() :
            CardSection(
              title: "Incomplete",
              gradient: MydoGradients.incompleteSection,
              taskCards: [ for ( var task in incomplete ) TaskCard(
                showCompleteButton: true,
                task: task,
                color: MydoColors.incompleteCard,
                onTap: () { openTaskEditor(task); },
                superSetState: () {
                  setState(() {});
                },
              )],
            ),

            CardSection(
              title: "Today",
              gradient: MydoGradients.todaySection,
              taskCards: !categoryMap.containsKey(PLANNED_TAG)
                  ? []
                  : [ for ( var task in categoryMap[PLANNED_TAG]! ) TaskCard(
                      showCompleteButton: true,
                      task: task,
                      color: MydoColors.untimedTodayCard,
                      onTap: () { openTaskEditor(task); },
                      superSetState: () {
                        setState(() {});
                      },
                    )],
            ),

            CardSection(
              title: "Soon",
              gradient: MydoGradients.soonSection,
              taskCards: !categoryMap.containsKey(SOON_TAG)
                  ? []
                  : [ for ( var task in categoryMap[SOON_TAG]! ) TaskCard(
                      showCompleteButton: true,
                      task: task,
                      color: MydoColors.soonCard,
                      onTap: () { openTaskEditor(task); },
                      superSetState: () {
                        setState(() {});
                      },
                    )],
            ),

            CardSection(
              title: "Eventually",
              gradient: MydoGradients.eventuallySection,
              taskCards: !categoryMap.containsKey(EVENTUALLY_TAG)
                  ? []
                  : [ for ( var task in categoryMap[EVENTUALLY_TAG]! ) TaskCard(
                      showCompleteButton: true,
                      task: task,
                      color: MydoColors.eventuallyCard,
                      onTap: () { openTaskEditor(task); },
                      superSetState: () {
                        setState(() {});
                      },
                    )],
            ),
          ],
        );
      }
    );
  }
}