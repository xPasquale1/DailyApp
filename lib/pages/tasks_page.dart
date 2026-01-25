import 'package:flutter/material.dart';
import 'package:daily_app/components/database.dart';
import 'package:daily_app/models/task.dart';
import 'package:daily_app/pages/task_view_page.dart';
import 'package:daily_app/widgets/task_widget.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TaskPageState();
  }
}

class _TaskPageState extends State<TasksPage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks = await DB.getAllTasks();
    setState(() {});
  }

  void onTaskCompleted(Task task) async {
    await DB.updateTask(task);
    setState(() {});
  }

  void onTaskPressed(Task task) async {
    final shouldDelete = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskViewPage(task: task)),
    );

    await DB.updateTask(task);
    setState(() {});

    if (shouldDelete == null || !shouldDelete) return;
    await DB.deleteTask(task);
    setState(() {
      tasks.remove(task);
    });
  }

  Future<void> addTaskDialog() async {
    final String? title = await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add new Task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Add new Task'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Add Task'),
            ),
          ],
        );
      },
    );
    if (title == null || title.isEmpty) return;
    Task? task = await DB.addTask(title, '');
    if (task == null) return;
    setState(() {
      tasks.add(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        centerTitle: true,
      ),
      body: tasks.isNotEmpty
          ? ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  task: tasks[index],
                  onToggle: (task) => onTaskCompleted(task),
                  onPress: (task) => onTaskPressed(task),
                );
              },
            )
          : Container(
              padding: EdgeInsets.all(64),
              child: Align(
                child: Text(
                  'There are currently no tasks. Add them using the Plus-Button.',
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
