class TodoItem {
  final String id;
  final String title;
  final String subtitle;
  final String image;


  TodoItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      image: json['image'],
    );
  }
}
