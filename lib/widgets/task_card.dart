import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// Format a date with intl
// https://stackoverflow.com/questions/16126579/how-do-i-format-a-date-with-dart
import 'dart:ui' as ui;

import 'package:mydo/classes/task.dart';
import 'package:mydo/persistence.dart';
import 'package:mydo/themes.dart';
import 'package:mydo/widgets/task_editor.dart';

import '../data/constants.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  String? taskText;
  final Function superSetState;
  final bool showCompleteButton;
  final bool showDeleteButton;
  final Function onTap;
  final Color color;
  final String table;
  //final Function(Task, String) submitTaskEdit;
  //final Function(Task) deleteTask;

  TaskCard({
    super.key,
    required this.task,
    required this.superSetState,
    this.showCompleteButton = false,
    this.showDeleteButton = false,
    required this.onTap,
    this.color = Colors.grey,
    this.table = 'tasks',
    //required this.submitTaskEdit,
    //required this.deleteTask,
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

    /*
    late Color cardColor;
    if (widget.task.category == PLANNED_TAG && widget.task.date == null) {
      cardColor = MydoColors.untimedTodayCard;
    } else if (widget.task.category == PLANNED_TAG) {
      cardColor = MydoColors.timedTodayCard;
    } else if (widget.task.category == SOON_TAG) {
      cardColor = MydoColors.soonCard;
    } else if (widget.task.category == EVENTUALLY_TAG){
      cardColor = MydoColors.eventuallyCard;
    } else if (widget.task.category == PAST_TAG) {
      cardColor = MydoColors.pastCard;
    } else {
      cardColor = Colors.grey;
    }
    */

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
                onTap: () {
                  if (widget.task.content != '') {
                    if (widget.task.id != null) { // Is this if check necessary?
                      widget.task.date = DateTime.now();
                      DatabaseHelper.instance.addHistoricalTask(widget.task);
                      DatabaseHelper.instance.remove('tasks', widget.task.id!);
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
                  widget.superSetState();
                },
              ),

            ],
          )
        ),
        onTap: () {
          /*
          // https://efficientcoder.net/flutter-alert-dialog/
          showGeneralDialog(
            barrierDismissible: true,
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            context: context,
            pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width-50,
                  height: MediaQuery.of(context).size.height-300,
                  decoration: BoxDecoration(
                    color: MydoColors.navbar
                  ),
                ),
              );
            }
          );
          */

          /*
          showDialog(
            context: context,
            builder: (context) {
              return TaskEditor(
                task: widget.task,
                onSubmit: () {
                  Navigator.pop(context);
                  widget.superSetState();
                },
              );
            }
          );

           */


          widget.onTap();

        },
      )
    );
  }
}