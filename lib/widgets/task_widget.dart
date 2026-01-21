import 'package:flutter/material.dart';
import 'package:daily_app/models/task.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  final Function(Task) onToggle;
  final Function(Task) onPress;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onPress,
  });

  @override
  State<StatefulWidget> createState() {
    return _TaskViewState();
  }
}

class _TaskViewState extends State<TaskItem> {
  void onCheck() {
    setState(() {
      widget.task.completed = !widget.task.completed;
    });
    widget.onToggle(widget.task);
  }

  void onPress(){
    widget.onPress(widget.task);
  }

  @override
  Widget build(Object context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: BoxBorder.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2),
              ),
              margin: EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: onCheck,
                icon: Icon(widget.task.completed ? Icons.check : null),
                iconSize: 20,
                padding: EdgeInsets.all(0),
              ),
            ),
            Text(
              widget.task.title,
              style: TextStyle(
                fontSize: 24,
                decoration: widget.task.completed ? TextDecoration.lineThrough : null,
                decorationThickness: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
