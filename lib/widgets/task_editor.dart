import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
//import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import 'package:mydo/classes/task.dart';
import 'package:mydo/persistence.dart';
import 'package:mydo/themes.dart';

import '../data/categories.dart';
import '../data/constants.dart';

class TaskEditor extends StatefulWidget {
  final Task task;
  String? taskText;
  final Function onSubmit;
  //final Function(Task, String) submitTaskEdit;
  //final Function(Task) deleteTask;

  TaskEditor({
    super.key,
    required this.task,
    required this.onSubmit,
    //required this.submitTaskEdit,
    //required this.deleteTask,
  });

  @override
  State<TaskEditor> createState() => _TaskEditor();
}



class _TaskEditor extends State<TaskEditor> {
  late Category selectedCategory;

  @override
  void initState() {
    selectedCategory = categoryFromName[widget.task.category]!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      backgroundColor: MydoColors.dialogBG,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        height: 305,
        child: Column(
          children: [
            TextField(
              onTapOutside: (event) {
                //FocusScope.of(context).requestFocus(new FocusNode());
              },
              controller: TextEditingController(text: widget.task.content),
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              minLines: 4,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MydoColors.dialogOutlineUnfocused, width: 2),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: MydoColors.dialogOutlineFocused, width: 5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MydoColors.dialogOutlineFocused, width: 2),
                ),
                hintText: "Enter task...",
              ),
              style: MydoText.dialogEditor,

              onChanged: (str) {
                widget.task.content = str;
              },
            ),

            SizedBox(height: 8),

            widget.task.date == null ? Container() :
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "At: ${DateFormat.jm().format(widget.task.date!)}   ${DateFormat.yMMMd().format(widget.task.date!)}"
                ),
                SizedBox(width: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),

                  onPressed: () {
                    setState(() {
                      widget.task.date = null;
                    });
                  },
                  child: Text("Reset", style: MydoText.resetButton,),
                )
              ],
            ),

            widget.task.date == null ? Container() :
            SizedBox(height: 8),

            CupertinoSegmentedControl(
              padding: EdgeInsets.all(0),
              groupValue: selectedCategory,
              selectedColor: categoryColors[selectedCategory],
              unselectedColor: MydoColors.segmentedButtonBG,
              borderColor: MydoColors.segmentedButtonBorder,
              onValueChanged: (Category newSelection) {
                setState(() {
                  selectedCategory = newSelection;
                });
              },
              children: <Category, Widget>{
                Category.planned: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: 200,
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Center(
                      child: Text("Plan"),
                    ),
                  ),
                ),
                Category.soon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Soon"),
                ),
                Category.eventually: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Later"),
                ),
              },
            ),

            SizedBox(height: 8),

            OverflowBar(
              spacing: 30,
              children: [

                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    if (widget.task.id != null) {
                      DatabaseHelper.instance.remove('tasks', widget.task.id!);
                    }
                    widget.onSubmit();
                  },
                ),

                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.date_range),
                  onPressed: () async {
                    DateTime? picked = await showOmniDateTimePicker(
                      context: context,
                    );
                    widget.task.date = picked;
                    setState(() {});

                    //widget.onSubmit();

                    /*
                    DatePicker.showDateTimePicker(
                      context,
                      currentTime: DateTime.now()
                    );
                    */
                  },
                ),

                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    if (widget.task.content != '') {
                      widget.task.category = nameFromCategory[selectedCategory]!;
                      if (widget.task.id != null) {
                        DatabaseHelper.instance.update(widget.task);
                      } else {
                        DatabaseHelper.instance.addTask(widget.task);
                      }
                    }
                    widget.onSubmit();
                  },
                ),


                /*
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.check_box_rounded),
                  onPressed: () {
                    if (widget.task.content != '') {
                      if (widget.task.id != null) {
                        DatabaseHelper.instance.addHistoricalTask(widget.task);
                        DatabaseHelper.instance.remove(widget.task.id!);
                      }
                    }
                    widget.onSubmit();
                  },
                ),
                */

              ],
            ),

          ],
        ),
      )
    );
  }
}