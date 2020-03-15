import 'package:crud_http_client/domain/interactors/task_use_case.dart';
import 'package:crud_http_client/domain/models/task.dart';
import 'package:crud_http_client/presentation/enums/priority.dart';
import 'package:crud_http_client/presentation/home/tasks_page.dart';
import 'package:crud_http_client/presentation/utils/pref.dart';
import 'package:flutter/material.dart';


class TaskEditPage extends StatefulWidget {
  final Task task;

  const TaskEditPage({
    Key key,
    this.task,
  }) : super(key: key);

  @override
  _TaskEditPageState createState() => _TaskEditPageState(task);
}

class _TaskEditPageState extends State<TaskEditPage> {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _priorityController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  String _titleTask;
  String _priorityTask;
  String _descriptionTask;
  Task task;
  Color _priorityColorH = Color(0xFFFFFFFF);
  Color _priorityColorM = Color(0xFFFFFFFF);
  Color _priorityColorL = Color(0xFFFFFFFF);
  Priority _priority;

  _TaskEditPageState(Task task) {
    this.task = task;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setPriorityColor();
    return Theme(
      data: ThemeData(
        primaryColor: Colors.grey.shade200,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: new Center(child: new Text("Edit Tasks", textAlign: TextAlign.center)),
          centerTitle: true,
          actions: [
            IconButton(
              color: Colors.white,
              icon: Icon(null),
              onPressed: () => null,
            ),
          ],
        ),
        body: taskDetailsLayoutWidget(task),
        bottomNavigationBar: Row(
          children: <Widget>[
            Container(
              child: MaterialButton(
                color: Colors.grey[100],
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () => _deleteTask(),
                child: Text(
                  "Delete event",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          foregroundColor: Colors.black54,
          backgroundColor: Colors.greenAccent,
          elevation: 0,
          mini: true,
          onPressed: () => onUpdateData(), //just update
        ),
      ),
    );
  }

  FutureBuilder _buildTaskDetails(Future data) {
    FutureBuilder futureBuilder = FutureBuilder<Task>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || snapshot.hasData == null) {
          return _buildTaskView(snapshot.data);
        } else {
          throw "No data";
        }
      },
    );
    return futureBuilder;
  }

  FutureBuilder _buildTaskView(Task data) {}

  Widget taskDetailsLayoutWidget(Task task) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(0.0),
              padding: EdgeInsets.all(0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _myTitleWidget(task),
                  _myPriorityWidget(task),
                  _myDescriptionWidget(task),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myTitleWidget(Task task) {
    return Container(
      margin: const EdgeInsets.only(
        left: 0,
        top: 0,
        right: 0,
        bottom: 0,
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          //Material example
          Row(
            children: <Widget>[
              Text("Title", textAlign: TextAlign.left),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          //Alternate
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter text',
                // labelText: 'Text field alternate'
                labelText: task.title ?? "empty"),
            controller: _titleController,
            maxLines: 3,
          ),
          SizedBox(
            height: 16.0,
          ),
          Divider(
            color: Colors.black87,
            height: 2,
          ),
        ],
      ),
    );
  }

  Widget _myPriorityWidget(Task task) {
    return Container(
      padding: EdgeInsets.all(0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Priority',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    _priorityController.text = "high";
                    _priorityColorH = Colors.red[200];
                    _priority = Priority.high;
                    setState(() {});
                  },
                  child: new Container(
                    width: 80,
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: _priorityColorH, border: Border.all(color: Colors.grey)),
                    child: Center(child: Text("High")),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _priorityController.text = "Normal";
                    _priorityColorM = Colors.grey[400];
                    _priority = Priority.medium;
                    setState(() {});
                  },
                  child: new Container(
                    width: 80,
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: _priorityColorM, border: Border.all(color: Colors.grey)),
                    child: Center(child: Text("Medium")),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    _priorityController.text = "Low";
                    _priorityColorL = Colors.orange[100];
                    _priority = Priority.low;
                    setState(() {});
                  },
                  child: new Container(
                    width: 80,
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: _priorityColorL, border: Border.all(color: Colors.grey)),
                    child: Center(child: Text("Low")),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _myDescriptionWidget(Task task) {
    return Container(
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            color: Colors.black87,
            height: 2,
          ),
          Row(
            children: [
              Text(
                ' Description',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter text',
                // labelText: 'Text field alternate'
                labelText: task.dueBy.toString() ?? "empty"),
            controller: new TextEditingController(),
            maxLines: 3,
          ),
          SizedBox(
            height: 16.0,
          ),
          Divider(
            color: Colors.black87,
            height: 2,
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notification',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Divider(
            color: Colors.black87,
            height: 2,
          ),
          SizedBox(
            height: 48.0,
          ),
        ],
      ),
    );
  }

  onUpdateData() async {
    Task editedTask = prepareTask();
    String token = await getLocalToken();
    TaskUseCase taskUseCase = TaskUseCase(token);
    await taskUseCase.updateTask(editedTask);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TasksPage()),
    );
  }

  Task prepareTask() {
    Task task = Task();
    task.id = this.task.id;
    task.title = this._titleController.text ?? this.task.title;
    task.priority = _priorityController.text ?? this.task.priority;
    //task.dueBy = new DateTime.now().toString();
    task.dueBy = 1549477494;
    return task;
  }

  void _deleteTask() async {
    if (task != null) {
      String token = await getLocalToken();
      TaskUseCase taskInteractor = new TaskUseCase(token);
      await taskInteractor.deleteTask(task);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TasksPage()),
      );
    } else {
      throw Exception('Task is null !');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setPriorityColor() {
    if (_priority == null) {
      _priorityColorH = Color(0xFFFFFFFF);
      _priorityColorM = Color(0xFFFFFFFF);
      _priorityColorL = Color(0xFFFFFFFF);
    } else if (_priority == Priority.high) {
      _priorityColorH = Colors.red[200];
      _priorityColorM = Color(0xFFFFFFFF);
      _priorityColorL = Color(0xFFFFFFFF);
    } else if (_priority == Priority.medium) {
      _priorityColorH = Color(0xFFFFFFFF);
      _priorityColorM = Colors.grey[400];
      _priorityColorL = Color(0xFFFFFFFF);
    } else if (_priority == Priority.low) {
      _priorityColorH = Color(0xFFFFFFFF);
      _priorityColorM = Color(0xFFFFFFFF);
      _priorityColorL = Colors.orange[100];
    } else {
      _priorityColorH = Color(0xFFFFFFFF);
      _priorityColorM = Color(0xFFFFFFFF);
      _priorityColorL = Color(0xFFFFFFFF);
    }
  }
}
