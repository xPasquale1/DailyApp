import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

class TaskViewPage extends StatefulWidget {
  final Task task;

  const TaskViewPage({super.key, required this.task});

  @override
  State<StatefulWidget> createState() {
    return _TaskViewPageState();
  }
}

class _TaskViewPageState extends State<TaskViewPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(
      text: widget.task.description,
    );
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(widget.task.title, style: TextStyle(fontSize: 32)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          setState(() {
            widget.task.title = titleController.text;
            widget.task.description = descriptionController.text;
          });
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            TextField(maxLines: 1, controller: titleController),
            Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            TextField(maxLines: null, controller: descriptionController),
            Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Delete Task',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
