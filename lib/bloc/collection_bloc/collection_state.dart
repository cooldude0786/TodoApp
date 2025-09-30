
import 'package:todo/models/collection.dart';

abstract class CollectionState {
  final List<Collection> collections;

  const CollectionState({this.collections = const <Collection>[]});
}

class CollectionInitial extends CollectionState {}

class CollectionLoaded extends CollectionState {
  const CollectionLoaded({required super.collections});
}