import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_firebase_bloc_app/notes_bloc/notes_event.dart';
import 'package:simple_firebase_bloc_app/notes_bloc/notes_state.dart';
import 'package:simple_firebase_bloc_app/notes_repository.dart';

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
class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository _notesRepository;
  StreamSubscription? _notesSubscription;

  NotesBloc(this._notesRepository) : super(NotesLoading()) {
    on<InitApp>(_onInitApp);
    on<AddNote>(_onAddNote);
    on<_NotesUpdated>(_onNotesUpdated);
  }

  Future<void> _onInitApp(InitApp event, Emitter<NotesState> emit) async {
    try {
      emit(NotesLoading());
      // Initialize repository (signs in user)
      await _notesRepository.init();
      // Cancel any existing subscription
      _notesSubscription?.cancel();
      // Listen to the stream of notes
      _notesSubscription = _notesRepository.getNotesStream().listen(
        (snapshot) {
          // Add an internal event when data changes
          add(_NotesUpdated(snapshot));
        },
        onError: (error) {
          emit(NotesError(error.toString()));
        },
      );
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  void _onNotesUpdated(_NotesUpdated event, Emitter<NotesState> emit) {
    // Emit the new list of notes
    emit(NotesLoaded(event.notesSnapshot.docs));
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    try {
      // No need to emit a new state here,
      // the stream listener in _onInitApp will do it automatically
      await _notesRepository.addNote(event.noteContent);
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}
