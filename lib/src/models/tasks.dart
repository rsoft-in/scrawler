import 'dart:convert';

class Task {
  String taskId;
  String taskTitle;
  List<TaskItem> taskItems; // json data for list of items
  String taskDueDate;
  bool taskReminder;
  int taskReminderType; // 0 for once, 1 for daily, 2 for weekly, 3 for monthly, 4 for yearly
  String taskReminderAttr;
  bool taskCompleted;
  String taskModified;

  Task(
      this.taskId,
      this.taskTitle,
      this.taskItems,
      this.taskDueDate,
      this.taskReminder,
      this.taskReminderType,
      this.taskReminderAttr,
      this.taskCompleted,
      this.taskModified);

  Task.fromJson(Map<String, dynamic> json)
      : taskId = json['task_id'],
        taskTitle = json['task_title'],
        taskItems = (json['task_items'] as List)
            .map((e) => TaskItem.fromJson(e))
            .toList(),
        taskDueDate = json['task_due_date'],
        taskReminder = (json['task_reminder'] == 1),
        taskReminderType = json['task_reminder_type'],
        taskReminderAttr = json['task_reminder_attr'],
        taskCompleted = (json['task_completed'] == 1),
        taskModified = json['task_modified'];

  Map<String, dynamic> toJson() => {
        'task_id': taskId,
        'task_title': taskTitle,
        'task_items': jsonEncode(taskItems),
        'task_due_date': taskDueDate,
        'task_reminder': taskReminder ? 1 : 0,
        'task_reminder_type': taskReminderType,
        'task_reminder_attr': taskReminderAttr,
        'task_completed': taskCompleted ? 1 : 0,
        'task_modified': taskModified
      };
}

class TaskItem {
  String item;
  bool completed;

  TaskItem(this.item, this.completed);

  TaskItem.fromJson(Map<String, dynamic> json)
      : item = json['item'],
        completed = (json['completed'] == 1);

  Map<String, dynamic> toJson() =>
      {'item': item, 'completed': completed ? 1 : 0};
}
