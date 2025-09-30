import 'package:hive/hive.dart';

part 'collection.g.dart';

@HiveType(typeId: 0)
class Collection {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  Collection({required this.id, required this.name});
}