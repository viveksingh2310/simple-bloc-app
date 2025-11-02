import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;

  // Sign in anonymously and get a user ID
  Future<void> init() async {
    if (_user == null) {
      final userCredential = await _auth.signInAnonymously();
      _user = userCredential.user;
    }
  }

  // Get a stream of notes from Firestore for the current user
  Stream<QuerySnapshot> getNotesStream() {
    if (_user == null) {
      throw Exception("User not initialized. Call init() first.");
    }
    // Return a stream of notes, ordered by timestamp
    return _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('notes')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Add a new note to Firestore
  Future<void> addNote(String noteContent) async {
    if (_user == null) {
      throw Exception("User not initialized. Call init() first.");
    }
    await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('notes')
        .add({
      'content': noteContent,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}