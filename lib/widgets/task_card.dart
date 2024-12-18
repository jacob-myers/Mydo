import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Format a date with intl
// https://stackoverflow.com/questions/16126579/how-do-i-format-a-date-with-dart
import 'dart:ui' as ui;

import 'package:mydo/classes/task.dart';
import 'package:mydo/persistence.dart';
import 'package:mydo/themes.dart';
import 'package:mydo/widgets/task_editor.dart';
import 'package:tuple/tuple.dart';

import '../data/constants.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final Function superSetState;
  final bool showCompleteButton;
  final bool showDeleteButton;
  final Function onTap;
  final Color color;
  final String table;

  TaskCard({
    super.key,
    required this.task,
    required this.superSetState,
    this.showCompleteButton = false,
    this.showDeleteButton = false,
    required this.onTap,
    this.color = Colors.grey,
    this.table = 'tasks',
  });

  @override
  State<TaskCard> createState() => _TaskCard();
}

class _TaskCard extends State<TaskCard> {
  final textFieldController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool beingEdited = false;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    String? time = widget.task.date != null ? DateFormat.jm().format(widget.task.date!) : null;

    return Card(
      margin: EdgeInsets.fromLTRB(3, 3, 3, 3),
      shadowColor: Colors.transparent,
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(8),
          ),
          //padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  textDirection: ui.TextDirection.ltr,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    time == null || widget.task.category != PLANNED_TAG ? SizedBox(height: 8) : Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(
                        time,
                        textDirection: ui.TextDirection.ltr,
                        style: TextStyle(color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                    //SizedBox(height: 4),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Text(
                        widget.task.content,
                        textDirection: ui.TextDirection.ltr,
                        style: MydoText.cardEditText,
                      ),
                    ),

                  ],
                ),
              ),

              // Show complete button if true.
              !widget.showCompleteButton ? Container() :
              InkWell(
                //customBorder:
                child: Container(
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.done,
                    color: Colors.black,
                  ),
                ),
                onTap: () async {
                  if (widget.task.content != '') {
                    if (widget.task.id != null) { // Is this if check necessary?
                      DatabaseHelper.instance.remove('tasks', widget.task.id!);
                      int histTaskID = await DatabaseHelper.instance.addHistoricalTask(Task(id: widget.task.id, category: widget.task.category, content: widget.task.content, date: DateTime.now()));
                      DatabaseHelper.previousActions.push(Tuple2(TaskAction.none, Task(id: histTaskID, category: '')));
                      DatabaseHelper.previousActions.push(Tuple2(TaskAction.mark, widget.task));
                    }
                  }
                  widget.superSetState();
                },
              ),

              !widget.showDeleteButton ? Container() :
              InkWell(
                child: Container(
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.delete_forever,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  DatabaseHelper.instance.remove(widget.table, widget.task.id!);
                  DatabaseHelper.previousActions.push(Tuple2(TaskAction.superdelete, widget.task));
                  widget.superSetState();
                },
              ),

            ],
          )
        ),
        onTap: () {
          widget.onTap();
        },
      )
    );
  }
}