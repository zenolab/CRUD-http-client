import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crud_http_client/data/network/network_config.dart';
import 'package:crud_http_client/data/utils/avaiablility_network.dart';
import 'package:crud_http_client/domain/models/task.dart';
import 'package:http/http.dart';
import 'package:crud_http_client/domain/services/task_service.dart';


class TaskService with BaseTaskService {
  static const String _taskEndPoint = "/tasks/";
  static const String _tasksEndPoint = "/tasks";
  static const String _createTaskEndPoint = "/tasks";
  static const String _updateTaskEndPoint = "/tasks/";
  static const String _deleteTaskEndPoint = "/tasks/";
  static const String _deleteTasksEndPoint = "/tasks";

  Map<String, String> _headers;
  String _url;
  bool _connected;

  Task _task;
  List<Task> _tasks;

  TaskService(String token) {
    this._headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
    };
  }

  @override
  Future<Task> getTask(Task task) async {
    _url = baseUrl + _taskEndPoint + task.id.toString();
    await checkConnectivity().then((internet) => _connected = internet);
    if (_connected) {
      return await get(_url, headers: _headers)
          .then(_handleResponseTaskDetails)
          .catchError((error) {
        throw "Error connection : " + error;
      }).whenComplete(() => print('-- TaskService completed'));
    } else {
      throw "Not accessible internet";
    }
  }

  @override
  Future<List<Task>> getAllTasks() async {
    _url = baseUrl + _tasksEndPoint.toString();
    print("getAllTasks url  $_url");
    print("getAllTasks _headers   $_headers ");
    await checkConnectivity().then((internet) => _connected = internet);
    if (_connected) {
      return await get(_url, headers: _headers).then(_handleResponseTasks).catchError((error) {
        throw "Error connection : " + error;
      }).whenComplete(() => print('-- TaskService completed'));
    } else {
      throw "Not accessible internet";
    }
  }

  @override
  FutureOr createTask(Task task) async {
    _url = baseUrl + _createTaskEndPoint;
    await checkConnectivity().then((internet) => _connected = internet);
    if (_connected) {
      await post(_url, body: requestBody(task), headers: _headers).then((response) {
        print("Response status: ${response.statusCode}");
      }).catchError((error) {
        throw "Error connection : " + error;
      }).whenComplete(() => print('-- TaskService completed'));
    } else {
      throw "Not accessible internet";
    }
  }

  @override
  FutureOr updateTask(Task task) async {
    _url = baseUrl + _updateTaskEndPoint + task.id.toString();
    await checkConnectivity().then((internet) => _connected = internet);
    if (_connected) {
      return await put(_url, body: requestBody(task), headers: _headers).then((response) {
        print("Response status: ${response.statusCode}");
      }).whenComplete(() => print('-- TaskService completed'));
    } else {
      throw "Not accessible internet";
    }
  }

  @override
  FutureOr deleteTask(Task task) async {
    _url = baseUrl + _deleteTaskEndPoint + task.id.toString();
    await checkConnectivity().then((internet) => _connected = internet);
    if (_connected) {
      return await delete(_url, headers: _headers).then((response) {
        print("Response status: ${response.statusCode}");
      }).whenComplete(() => print('-- TaskService completed'));
    } else {
      throw "Not accessible internet";
    }
  }

  @override
  FutureOr deleteAllTasks() async {
    _url = baseUrl + _deleteTasksEndPoint.toString();
    await checkConnectivity().then((internet) => _connected = internet);
    if (_connected) {
      return await delete(_url, headers: _headers).then((response) {
        print("Response status: ${response.statusCode}");
      }).whenComplete(() => print('-- TaskService completed'));
    } else {
      throw "Not accessible internet";
    }
  }

  FutureOr<dynamic> _handleResponseTasks(Response response) {
    if (response.statusCode < 200 || response.statusCode > 400 || response.body == null) {
      throw new Exception("Error while fetching data");
    }
    if (jsonDecode(response.body)['tasks'] == null) throw "Can't get data!";
    print("  -- data response ${response.body.toString()}");
    List<dynamic> restData = jsonDecode(response.body)['tasks'] as List;
    _tasks = restData.map((dynamic item) => Task.fromJson(item)).toList();
    return _tasks;
  }

  FutureOr<Task> _handleResponseTaskDetails(Response response) {
    if (response.statusCode < 200 || response.statusCode > 400 || response.body == null) {
      throw new Exception("Error while fetching data");
    }
    if (jsonDecode(response.body)['task'] == null) throw "Can't get data!";
    final responseJson = json.decode(response.body);
    return Task.fromJson(responseJson['task']);
  }

  String requestBody(Task task) {
    Map data = Task(title: task.title, dueBy: task.dueBy, priority: task.priority).toMapWithoutId();
    String requestBody = json.encode(data);
    return requestBody;
  }
}
