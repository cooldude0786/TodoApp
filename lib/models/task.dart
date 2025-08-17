
class Task {
  final String id;
  final String title;
  final String collectionId;
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.collectionId,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    String? collectionId,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      collectionId: collectionId ?? this.collectionId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}