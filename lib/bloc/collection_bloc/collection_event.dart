
import 'package:todo/models/collection.dart';

abstract class CollectionEvent {}

class AddCollection extends CollectionEvent {
  final Collection collection;

  AddCollection({required this.collection});
}

class DeleteCollection extends CollectionEvent {
  final String collectionId;

  DeleteCollection({required this.collectionId});
}