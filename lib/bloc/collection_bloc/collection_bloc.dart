import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'collection_event.dart';
import 'collection_state.dart';
import '../../models/collection.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final Box<Collection> _collectionBox;

  CollectionBloc()
      : _collectionBox = Hive.box<Collection>('collections'),
        // MODIFIED: Load initial data from the Hive box
        super(CollectionLoaded(collections: Hive.box<Collection>('collections').values.toList())) {
    on<AddCollection>(_onAddCollection);
    on<DeleteCollection>(_onDeleteCollection);
  }

  void _onAddCollection(AddCollection event, Emitter<CollectionState> emit) {
    _collectionBox.put(event.collection.id, event.collection); // Save to Hive
    emit(CollectionLoaded(collections: _collectionBox.values.toList())); // Emit new state from Hive
  }

  void _onDeleteCollection(DeleteCollection event, Emitter<CollectionState> emit) {
    _collectionBox.delete(event.collectionId); // Delete from Hive
    emit(CollectionLoaded(collections: _collectionBox.values.toList())); // Emit new state from Hive
  }
}