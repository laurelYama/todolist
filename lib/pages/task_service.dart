import 'package:cloud_firestore/cloud_firestore.dart';
import 'task.dart';

class TaskService {
  final CollectionReference taskCollection = FirebaseFirestore.instance.collection('tasks');

  // Ajouter une tâche
  Future<void> addTask(Task task) async {
    await taskCollection.add(task.toMap());
  }

  // Modifier une tâche
  Future<void> updateTask(Task task) async {
    await taskCollection.doc(task.id).update(task.toMap());
  }

  // Supprimer une tâche
  Future<void> deleteTask(String id) async {
    await taskCollection.doc(id).delete();
  }

  // Récupérer les tâches en temps réel
  Stream<List<Task>> getTasks() {
    return taskCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
    });
  }
}
