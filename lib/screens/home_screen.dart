import 'package:flutter/material.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tasks = [];

  void _addTask() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Task'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Enter task')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => tasks.add({'title': controller.text, 'isDone': false}));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks'), centerTitle: true),
      body: tasks.isEmpty 
        ? const Center(child: Text('No tasks yet!'))
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Checkbox(
                  value: tasks[index]['isDone'],
                  onChanged: (val) => setState(() => tasks[index]['isDone'] = val),
                ),
                title: Text(
                  tasks[index]['title'],
                  style: TextStyle(decoration: tasks[index]['isDone'] ? TextDecoration.lineThrough : null),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditTaskScreen(currentTitle: tasks[index]['title'])),
                    );
                    if (result != null) {
                      if (result['action'] == 'delete') {
                        setState(() => tasks.removeAt(index));
                      } else if (result['action'] == 'update') {
                        setState(() => tasks[index]['title'] = result['title']);
                      }
                    }
                  },
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(onPressed: _addTask, child: const Icon(Icons.add)),
    );
  }
}