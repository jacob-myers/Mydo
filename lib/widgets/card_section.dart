import 'package:flutter/material.dart';

// Local
import 'package:mydo/themes.dart';
import 'package:mydo/widgets/task_card.dart';

class CardSection extends StatefulWidget {
  String title;
  List<TaskCard> taskCards;
  String? taskText;
  Gradient? gradient;

  CardSection({
    super.key,
    this.title = "Title",
    required this.taskCards,
    this.gradient,
  });

  @override
  State<CardSection> createState() => _CardSection();
}

class _CardSection extends State<CardSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                widget.title,
                style: MydoText.categoryHeaders,
              ),
            ),
            Column(
              children: widget.taskCards,
            )
          ],
        ),
      ),
    );
  }

}