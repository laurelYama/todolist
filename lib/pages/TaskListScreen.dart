import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'task_service.dart';
import 'task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService taskService = TaskService();

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.blue.shade700,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title:
            Text('To-Do List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Task>>(
        stream: taskService.getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          List<Task> tasks = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              Task task = tasks[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(task.description,
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                  leading: Checkbox(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    value: task.isCompleted,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      task.isCompleted = value!;
                      taskService.updateTask(task);
                      if (task.isCompleted) {
                        _showSnackbar("✔ Tâche complète !");
                      }
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue.shade700),
                        onPressed: () => _editTask(context, task),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red.shade700),
                        onPressed: () => _confirmDeleteTask(context, task),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        icon: Icon(Icons.add),
        label: Text("Nouvelle tâche"),
        onPressed: () => _addTask(context),
      ),
    );
  }

  void _addTask(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Ajouter une tâche",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Titre")),
            SizedBox(height: 10),
            TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description")),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Annuler", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700),
            child: Text("Ajouter", style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                taskService.addTask(Task(
                  id: '',
                  title: titleController.text,
                  description: descriptionController.text,
                ));
                Navigator.pop(context);
                _showSnackbar("✅ Tâche ajoutée avec succès !");
              }
            },
          ),
        ],
      ),
    );
  }

  void _editTask(BuildContext context, Task task) {
    TextEditingController titleController =
        TextEditingController(text: task.title);
    TextEditingController descriptionController =
        TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("Modifier la tâche",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Titre")),
            SizedBox(height: 10),
            TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description")),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Annuler", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700),
            child: Text("Modifier", style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                taskService.updateTask(Task(
                  id: task.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  isCompleted: task.isCompleted,
                ));
                Navigator.pop(context);
                _showSnackbar("✏ Tâche modifiée avec succès !");
              }
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTask(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Supprimer la tâche ?"),
        content: Text("Voulez-vous vraiment supprimer cette tâche ?"),
        actions: [
          TextButton(
            child:
                Text("Annuler", style: TextStyle(color: Colors.blue.shade700)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Supprimer", style: TextStyle(color: Colors.red)),
            onPressed: () {
              taskService.deleteTask(task.id);
              Navigator.pop(context);
              _showSnackbar("🗑 Tâche supprimée avec succès !");
            },
          ),
        ],
      ),
    );
  }
}
