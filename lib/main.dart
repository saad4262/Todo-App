import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart'; // Add this import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<String> _todoItems = [];
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Function to add a new task to the list

  void _addTodoItem(String task) {
    if (task.isNotEmpty) {
      final currentTime = DateTime.now();
      final formattedTime = DateFormat('hh:mm a').format(currentTime); // Format time as "12:00 PM"

      setState(() {
        _todoItems.add('$task - $formattedTime'); // Append timestamp to task
      });
      _textController.clear();
    }
  }
  // Function to remove a task from the list
  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  // Function to edit an existing task
  void _editTodoItem(int index) {
    final taskParts = _todoItems[index].split(' - ');
    final taskText = taskParts[0];
    final timestamp = taskParts[1];

    _textController.text = taskText; // Set the text controller to only the task text

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Note'),
          content: TextField(
            controller: _textController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Update Note',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  // Reconstruct the todo item with the original timestamp
                  _todoItems[index] = '${_textController.text} - $timestamp';
                });
                _textController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to build the list of tasks
  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todoItems.length,
      itemBuilder: (context, index) {
        return _buildTodoItem(_todoItems[index], index);
      },
    );
  }

  // Function to build individual task items with slide actions
  Widget _buildTodoItem(String task, int index) {
    final taskText = task.split(' - ')[0];
    final timestamp = task.split(' - ')[1];

    return Slidable(
      key: Key(task), // Unique key for each item
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => _removeTodoItem(index),
        ),
        children: [
          SlidableAction(
            onPressed: (context) => _editTodoItem(index),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => _removeTodoItem(index), // Immediate deletion
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        color: Color(0XFFFEE9A8),
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Stack(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                taskText, // Display task text
                style: TextStyle(
                  fontFamily: "Schyler",
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              right: 16, // Distance from the right edge
              bottom: 16, // Distance from the bottom edge
              child: Text(
                timestamp, // Display timestamp
                style: TextStyle(
                  fontFamily: "Schyler",
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Function to build the input field for adding new tasks
  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    child: Icon(Icons.note_alt_rounded, color: Colors.black),
                    backgroundColor: Color(0XFFFEE9A8),
                  ),
                ),
                labelText: 'Enter Note',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _addTodoItem(_textController.text),
            backgroundColor: Color(0XFFFEE9A8),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Todo App',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "Schyler",
            ),
          ),
        ),
        leading:Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Color(0XFFFEE9A8),

            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer(); // Open the custom drawer
              },
            ),
          ),
        ),
        actions: [
          CircleAvatar(
            radius: 30.0, // Adjust the radius as needed
            backgroundImage: AssetImage('assets/images/saad.jpg'),
          ),
        ],
      ),
      drawer: CustomDrawer(), // Use drawer property here
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildTodoList(),
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }
}

// Custom Drawer Widget
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Width of the custom drawer
      color: Color(0XFFFEE9A8), // Background color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 50), // Adjust the top margin
          Container(
            padding: EdgeInsets.all(20),
            color: Color(0XFFFEE9A8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
              children: [
                CircleAvatar(
                  radius: 30.0, // Adjust the radius as needed
                  backgroundImage: AssetImage('assets/images/saad.jpg'),
                ),
                SizedBox(height: 10), // Adjust the spacing between image and text
                Text(
                  'Muhammad Saad Nadeem',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home, color: Colors.black),
                  title: Text('Home', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Handle navigation
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.black),
                  title: Text('Settings', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Handle navigation
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contact_page, color: Colors.black),
                  title: Text('Contact', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Handle navigation
                    Navigator.pop(context); // Close the drawer
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.black),
            title: Text('Logout', style: TextStyle(fontSize: 18)),
            onTap: () {
              // Handle logout
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
