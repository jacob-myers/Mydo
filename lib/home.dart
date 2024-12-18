import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:intl/intl.dart';
import 'package:mydo/main.dart';
import 'package:mydo/persistence.dart';
import 'package:mydo/themes.dart';
import 'package:mydo/widgets/card_section.dart';
import 'package:mydo/widgets/historical_list.dart';
import 'package:mydo/widgets/home_list.dart';
import 'package:mydo/widgets/planned_list.dart';
import 'package:mydo/widgets/task_card.dart';
import 'package:mydo/widgets/task_editor.dart';

import 'classes/task.dart';
import 'data/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Body { home, historic, planned }
/*
Map<Body, Function> bodyTaskFunctions = <Body, Function>{
  Body.home: DatabaseHelper.instance.getTasks,
  Body.historic: DatabaseHelper.instance.getHistoricalTasks,
};
*/

class _HomePageState extends State<HomePage> {
  Body bodyType = Body.home;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // So bottom bar disappears with keyboard.
      resizeToAvoidBottomInset: false,
      /*
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.title),
      ),

       */
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //SizedBox(height: 50,),

            Expanded(
              // Picks which list to use.
              child: bodyType == Body.home ? HomeList(superSetState: () { setState(() {}); }) :
                  bodyType == Body.historic ? HistoricalList(superSetState: () { setState(() {}); }) :
                  bodyType == Body.planned ? PlannedList(superSetState: () { setState(() {}); }) :
                  const Center(child: Text("Error"),)
            ),

            Container(
              decoration: BoxDecoration(
                  color: MydoColors.navbar,
                  boxShadow: [
                    BoxShadow(
                      color: MydoColors.navbar.withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 7,
                      //offset: Offset(0, 3),
                    )
                  ]
              ),
              child: Row(
                children: [
                  Spacer(),
                  OverflowBar(
                    spacing: 12,
                    //spacing: 45,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            DatabaseHelper.instance.undo();
                          });
                        },
                        iconSize: 40,
                        icon: const Icon(Boxicons.bx_undo),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            bodyType = Body.historic;
                          });
                        },
                        iconSize: 40,
                        icon: const Icon(Icons.history),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            bodyType = Body.home;
                          });
                        },
                        iconSize: 40,
                        icon: const Icon(Icons.home),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            bodyType = Body.planned;
                          });
                        },
                        iconSize: 40,
                        icon: const Icon(Icons.calendar_month),
                      ),
                      IconButton(
                        onPressed: () async {
                          Task newTask = Task(content: '', category: 'planned');
                          showDialog(
                              context: context,
                              builder: (context) {
                                return TaskEditor(
                                  task: newTask,
                                  onSubmit: () {
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                );
                              }
                          );
                        },
                        iconSize: 40,
                        icon: const Icon(Icons.add_box),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}