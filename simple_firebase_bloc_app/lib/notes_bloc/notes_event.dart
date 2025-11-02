import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

// Event to initialize the app (sign in and load)
class InitApp extends NotesEvent {}
// Event to add a new note
class AddNote extends NotesEvent {
  final String noteContent;

  const AddNote(this.noteContent);

  @override
  List<Object> get props => [noteContent];
}

// Internal event to update the UI when new data arrives from Firestore
// ignore: unused_element
class _NotesUpdated extends NotesEvent {
  final QuerySnapshot notesSnapshot;

  const _NotesUpdated(this.notesSnapshot);

  @override
  List<Object> get props => [notesSnapshot];
}