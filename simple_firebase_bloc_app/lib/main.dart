import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_firebase_bloc_app/app.dart';
import 'package:simple_firebase_bloc_app/notes_bloc/notes_bloc.dart';
// import 'package:simple_firebase_bloc_app/notes_bloc/notes_event.dart';
import 'package:simple_firebase_bloc_app/notes_repository.dart';
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // <-- Must be first
//   await Firebase.initializeApp(         // <-- Must be second
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   // ... rest of the code
//   final notesRepository = NotesRepository();
//   //...
// }
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Create our repository
  final notesRepository = NotesRepository();

  // Run the app
  runApp(
    // Provide the repository to the app
    RepositoryProvider.value(
      value: notesRepository,
      child: BlocProvider(
        create: (context) => NotesBloc(notesRepository)..add(InitApp()),
        child: const MyApp(),
      ),
    ),
  );
}