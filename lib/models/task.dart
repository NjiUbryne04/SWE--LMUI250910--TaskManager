// Task model — defines the structure of a single task in our app.
// A Dart class is like a blueprint; each Task object is built from this blueprint.

class Task {
  String title;
  String description;
  String category; // e.g. School, Personal, Health, Work, Finance
  String priority; // Low, Medium, or High
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false, // defaults to false (not done yet)
  });
}
