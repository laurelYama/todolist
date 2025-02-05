class Task {
  String id;
  String title;
  String description;
  bool isCompleted;

  Task({required this.id, required this.title, required this.description, this.isCompleted = false});

  // Convertir une tâche en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  // Créer une tâche à partir d'un document Firestore
  factory Task.fromMap(String id, Map<String, dynamic> data) {
    return Task(
      id: id,
      title: data['title'],
      description: data['description'],
      isCompleted: data['isCompleted'] ?? false,
    );
  }
}
