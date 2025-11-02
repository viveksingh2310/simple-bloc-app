import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_firebase_bloc_app/notes_bloc/notes_bloc.dart';
// import 'package:simple_firebase_bloc_app/notes_bloc/notes_event.dart';
import 'package:simple_firebase_bloc_app/notes_bloc/notes_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase BLoC Notes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotesLoaded) {
            if (state.notes.isEmpty) {
              return const Center(
                child: Text('No notes yet. Add one!'),
              );
            }
            return ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                // Handle potential data inconsistencies
                final noteData = note.data() as Map<String, dynamic>?;
                final content = noteData?['content'] as String? ?? 'No content';
                
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(content),
                  ),
                );
              },
            );
          }
          if (state is NotesError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Unknown state.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to add a note
          noteController.clear();
          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: const Text('Add Note'),
                content: TextField(
                  controller: noteController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Note content',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (noteController.text.isNotEmpty) {
                        // Add the event to the BLoC
                        context
                            .read<NotesBloc>()
                            .add(AddNote(noteController.text));
                        Navigator.of(dialogContext).pop();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}