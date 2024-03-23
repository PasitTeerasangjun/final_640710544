class TodoItem {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  TodoItem({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}
