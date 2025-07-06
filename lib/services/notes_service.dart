import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user's ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Get the notes collection reference for the current user
  CollectionReference<Map<String, dynamic>> get _notesCollection {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not authenticated');
    return _firestore.collection('users').doc(userId).collection('notes');
  }

  // Fetch all notes for the current user
  Future<List<Note>> fetchNotes() async {
    try {
      final querySnapshot = await _notesCollection
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return Note.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  // Add a new note
  Future<Note> addNote(String text) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final now = DateTime.now();
      final noteData = {
        'text': text,
        'userId': userId,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      };

      final docRef = await _notesCollection.add(noteData);
      final doc = await docRef.get();

      return Note.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  // Update an existing note
  Future<void> updateNote(String id, String text) async {
    try {
      await _notesCollection.doc(id).update({
        'text': text,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    try {
      await _notesCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }
} 