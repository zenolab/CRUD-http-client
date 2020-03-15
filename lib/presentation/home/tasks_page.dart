import 'dart:async';

import 'package:crud_http_client/domain/interactors/task_use_case.dart';
import 'package:crud_http_client/domain/models/task.dart';
import 'package:crud_http_client/presentation/home/task_details.dart';
import 'package:crud_http_client/presentation/utils/pref.dart';
import 'package:crud_http_client/presentation/utils/simple_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'crete_task.dart';


class TasksPage extends StatefulWidget {
  const TasksPage({
    Key key,
  }) : super(key: key);

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with WidgetsBindingObserver {
  List<Task> tasks = List<Task>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final List<String> _dropdownValues = [
    "Name",
    "Priority",
    "Date"
  ]; //The list of values we want on the dropdown

  String _currentlySelected = ""; //var to hold currently selected value

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
          title: Text('My Tasks'),
          centerTitle: true,
          leading: Icon(
            Icons.stars,
          ),
          actions: <Widget>[
            InkWell(
              child: Icon(
                Icons.sort,
              ),
              onTap: () {},
            ),
            SizedBox(width: 5),
            dropdownWidget(),
          ],
        ),
        body: RefreshIndicator(onRefresh: refresh, child: _buildTasks(_getTasks())),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          foregroundColor: Colors.black54,
          backgroundColor: Colors.orangeAccent,
          elevation: 0,
          mini: true,
          onPressed: () => onCreateTask(), //just update
        ),
      ),
    );
  }

  Widget dropdownWidget() {
    return DropdownButton(
      items: _dropdownValues
          .map((value) => DropdownMenuItem(
                child: Text(value),
                value: value,
              ))
          .toList(),
      onChanged: (String value) {
        setState(() {
          _currentlySelected = value;
        });
      },
      isExpanded: false,
      value: _dropdownValues.first,
    );
  }

  FutureBuilder _buildTasks(Future data) {
    FutureBuilder futureBuilder = FutureBuilder<List<Task>>(
      future: data,
      builder: (context, snapshot) {
        var childCount = 0;
        if (snapshot.connectionState != ConnectionState.done || snapshot.hasData == null) {
          childCount = 1;
          return Center(child: Text('Load data...'));
        } else if (snapshot.data != null) {
          childCount = snapshot.data.length;
          return RefreshIndicator(onRefresh: refresh, child: _buildListView(snapshot.data));
        } else {
          childCount = 0;
          return RefreshIndicator(onRefresh: refresh, child: Center(child: Text('Empty')));
        }
      },
    );
    return futureBuilder;
  }

  Future<void> refresh() {
    _getTasks();
    setState(() {});
    return Future.value();
  }

  ListView _buildListView(List<Task> tasks) {
    tasks = onSort(tasks);
    return ListView.builder(
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(
            '${Text(tasks[i].title)}',
          ),
          subtitle: Row(
            children: <Widget>[
              Text(simpleFormatDate(tasks[i].dueBy.toString())),
              SizedBox(
                width: 32,
              ),
              Icon(
                Icons.label,
                color: Colors.grey[300],
              ),
              SizedBox(
                width: 4,
              ),
              Text(tasks[i].priority.toString()),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskDetailPage(task: tasks[i])),
              );
            },
          ),
        );
      },
      itemCount: tasks.length,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    removeValues();
    super.dispose();
  }

  Future<List<Task>> _getTasks() async {
    tasks.clear();
    String token = await getLocalToken();
    TaskUseCase taskInteractor = new TaskUseCase(token);
    tasks = await taskInteractor.getAllTasks();
    return tasks;
  }

  onCreateTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskCreatePage()),
    );
  }

  List<Task> onSort(List<Task> tasks) {
    if (_currentlySelected == "Name") {
      return tasks..sort((a, b) => a.title.compareTo(b.title));
    } else if (_currentlySelected == "Priority") {
      return tasks..sort((a, b) => a.priority.compareTo(b.priority));
    } else if (_currentlySelected == "Date") {
      return tasks..sort((a, b) => a.dueBy.compareTo(b.dueBy));
    } else {
      return tasks;
    }
  }
}
