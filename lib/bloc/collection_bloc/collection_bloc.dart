import 'package:flutter_bloc/flutter_bloc.dart';
import 'collection_event.dart';
import 'collection_state.dart';
import 'package:todo/models/collection.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  CollectionBloc() : super(CollectionInitial()) {
    on<AddCollection>(_onAddCollection);
    on<DeleteCollection>(_onDeleteCollection);
  }

  void _onAddCollection(AddCollection event, Emitter<CollectionState> emit) {
    final updatedList = List<Collection>.from(state.collections)..add(event.collection);
    emit(CollectionLoaded(collections: updatedList));
  }

  void _onDeleteCollection(DeleteCollection event, Emitter<CollectionState> emit) {
    final updatedList = state.collections.where((col) => col.id != event.collectionId).toList();
    emit(CollectionLoaded(collections: updatedList));
  }
}
