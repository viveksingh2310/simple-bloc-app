import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

// Initial state, app is loading
class NotesLoading extends NotesState {}

// State when notes are successfully loaded
class NotesLoaded extends NotesState {
  final List<QueryDocumentSnapshot> notes;

  const NotesLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}

// State when an error occurs
class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object> get props => [message];
}