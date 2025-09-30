import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String collectionId;

  @HiveField(3)
  final bool isCompleted;

  @HiveField(4)
  final DateTime? reminderTime;

  Task({
    required this.id,
    required this.title,
    required this.collectionId,
    this.isCompleted = false,
    this.reminderTime,
  });

  Task copyWith({
    String? id,
    String? title,
    String? collectionId,
    bool? isCompleted,
    DateTime? reminderTime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      collectionId: collectionId ?? this.collectionId,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}