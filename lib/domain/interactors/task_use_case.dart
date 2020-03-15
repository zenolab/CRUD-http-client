import 'dart:async';
import 'package:crud_http_client/data/repository/task_reposotory.dart';
import 'package:crud_http_client/domain/models/task.dart';

import 'base/base_task_use_case.dart';

class TaskUseCase extends BaseTaskUseCase {
  TaskService _taskService;
  Task _task;
  List<Task> _tasks;

  TaskUseCase(String token) {
    print("--TaskUseCase  token $token");
    this._taskService = TaskService(token);
  }

  @override
  Future<List<Task>> getAllTasks() async {
    _tasks = await _taskService.getAllTasks();
    return _tasks;
  }

  @override
  Future<Task> getTask(Task task) async {
      _task = await _taskService.getTask(task);
      return _task;
  }

  @override
  FutureOr createTask(Task task) async {
     await _taskService.createTask(task);
  }

  @override
  FutureOr updateTask(Task task) async {
    _task = await _taskService.updateTask(task);
    return null;
  }

  @override
  FutureOr deleteAllTasks() async {
    _task = await _taskService.deleteAllTasks();
  }

  @override
  FutureOr deleteTask(Task task) async {
    _task = await _taskService.deleteTask(task);
  }


}
