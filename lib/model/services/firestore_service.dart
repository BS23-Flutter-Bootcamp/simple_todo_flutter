import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_todo_flutter/model/task.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> syncTask(String userId, Task task) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw 'No authenticated user found';
    }
    if (currentUser.uid != userId) {
      throw 'UID mismatch: authenticated user (${currentUser.uid}) does not match requested user ($userId)';
    }

    final taskRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(task.id.toString());
    await taskRef.set(task.toMap());
  }

  Future<void> deleteTask(String userId, int taskId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw 'No authenticated user found';
    }
    if (currentUser.uid != userId) {
      throw 'UID mismatch: authenticated user (${currentUser.uid}) does not match requested user ($userId)';
    }

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId.toString())
        .delete();
  }

  Future<List<Task>> getTasks(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw 'No authenticated user found';
    }
    if (currentUser.uid != userId) {
      throw 'UID mismatch: authenticated user (${currentUser.uid}) does not match requested user ($userId)';
    }

    final snapshot =
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('tasks')
            .get();
    return snapshot.docs.map((doc) {
      return Task.fromFirestore(doc.id, doc.data(), userId);
    }).toList();
  }

  Future<void> setLastSyncTime(String userId, DateTime time) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw 'No authenticated user found';
    }
    if (currentUser.uid != userId) {
      throw 'UID mismatch: authenticated user (${currentUser.uid}) does not match requested user ($userId)';
    }

    await _firestore.collection('users').doc(userId).set({
      'lastSync': time.toIso8601String(),
    }, SetOptions(merge: true));
  }

  Future<DateTime?> getLastSyncTime(String userId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw 'No authenticated user found';
    }
    if (currentUser.uid != userId) {
      throw 'UID mismatch: authenticated user (${currentUser.uid}) does not match requested user ($userId)';
    }

    final doc = await _firestore.collection('users').doc(userId).get();
    final data = doc.data();
    if (data != null && data['lastSync'] != null) {
      return DateTime.parse(data['lastSync']);
    }

    return null;
  }
}
