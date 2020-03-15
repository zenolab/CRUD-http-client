import 'dart:convert';
import 'dart:ffi';

Task taskFromJson(String str) {
  final jsonData = json.decode(str);
  return Task.fromJson(jsonData);
}

String taskToJson(Task data) {
  return json.encode(data.toMap());
}

class Task {
  dynamic id;
  dynamic title;
  dynamic dueBy;
  dynamic priority;

  Task({
    this.id,
    this.title,
    this.dueBy,
    this.priority,
  });

  factory Task.fromJson(Map<String, dynamic> json) => new Task(
        id: json["id"],
        title: json["title"],
        dueBy: json["dueBy"],
        priority: json["priority"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "dueBy": dueBy,
        "priority": priority,
      };

  Map<String, dynamic> toMapWithoutId() => {
    "title": title,
    "dueBy": dueBy,
    "priority": priority,
  };

}
