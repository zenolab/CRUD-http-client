import 'package:crud_http_client/domain/interactors/task_use_case.dart';
import 'package:crud_http_client/domain/models/task.dart';
import 'package:crud_http_client/presentation/home/task_edit.dart';
import 'package:crud_http_client/presentation/home/tasks_page.dart';
import 'package:crud_http_client/presentation/utils/pref.dart';
import 'package:crud_http_client/presentation/utils/simple_data.dart';
import 'package:flutter/material.dart';


class TaskDetailPage extends StatefulWidget {
  final Task task;

  const TaskDetailPage({
    Key key,
    this.task,
  }) : super(key: key);

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState(this.task);
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  Task task;

  _TaskDetailPageState(Task task) {
    this.task = task;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.grey.shade200,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(child: Text('Tasks Details')),
          actions: _onEdit(task),
        ),
        body: _buildTasks(_getTaskDetails(task)),
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
      ),
    );
  }

  FutureBuilder _buildTasks(Future<Task> data) {
    FutureBuilder futureBuilder = FutureBuilder<Task>(
      future: data,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || snapshot.hasData == null) {
          return Center(child: Text('Load data...'));
        } else if (snapshot.data != null) {
          return _taskDetailsLayoutWidget(snapshot.data);
        } else {
          return Center(child: Text('Empty'));
        }
      },
    );
    return futureBuilder;
  }

  Widget _taskDetailsLayoutWidget(Task task) {
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
                children: [
                  _myTitleWidget(task),
                  _myPriorityWidget(task),
                  _myDescriptionWidget(task),
                  _myNotificationWidget(),
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
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 0,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                task.title.toString(),
                style:
                    TextStyle(color: Colors.black87, fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                simpleFormatDate(task.dueBy.toString()),
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _myPriorityWidget(Task task) {
    return Container(
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Priority',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.label,
                      color: Colors.grey,
                    ),
                    Text(
                      task.priority.toString(),
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
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
        ],
      ),
    );
  }

  Widget _myDescriptionWidget(Task task) {
    return Container(
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 8.0,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Description',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                task.dueBy.toString(),
                style:
                    TextStyle(color: Colors.black87, fontSize: 14.0, fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _myNotificationWidget({Task task}) {
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
              Text(
                'Before',
                style: TextStyle(
                  color: Colors.black54,
                ),
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<Task> _getTaskDetails(Task task) async {
    if (task != null) {
      String token = await getLocalToken();
      TaskUseCase taskInteractor = new TaskUseCase(token);
      Task t = await taskInteractor.getTask(task);
      return t;
    } else {
      throw Exception('Task is null !');
    }
  }

  List<Widget> _onEdit(Task task) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.edit),
        tooltip: 'Edit',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskEditPage(task: task)),
          );
        },
      )
    ];
  }

  void _deleteTask() async {
    if (task != null) {
      String token = await getLocalToken();
      TaskUseCase taskInteractor = new TaskUseCase(token);
      await taskInteractor.deleteTask(task);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TasksPage()),
      );
    } else {
      throw Exception('Task is null !');
    }
  }
}
