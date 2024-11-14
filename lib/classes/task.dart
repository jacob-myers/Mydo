import 'package:intl/intl.dart';

class Task {
  int? id;
  DateTime? date;
  String content;
  String category; // "planned", "soon", "eventually"

  Task(
    {
      this.id,
      required this.category,
      this.content = "",
      this.date,
    }
  );

  // For creating Tasks from current table.
  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
        id: json['id'],
        category: json.containsKey('category') ? json['category'] : 'past',
        content: json['content'],
        date: int.parse(json['date'].toString()) == 0 ? null : DateTime.fromMillisecondsSinceEpoch(int.parse(json['date'].toString()))
    );
  }

  // Converting to json for storing in db.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date == null ? 0 : date!.millisecondsSinceEpoch,
      'content': content,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, date: ${date}, content: $content, category: $category';
  }
}