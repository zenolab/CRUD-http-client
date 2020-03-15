import 'dart:async';

import 'package:crud_http_client/domain/models/task.dart';

abstract class BaseTaskUseCase {

  Future<Task> getTask(Task task);

  Future<List<Task>> getAllTasks();

  FutureOr<dynamic> createTask(Task task);

  FutureOr<dynamic> updateTask(Task task);

  FutureOr<dynamic> deleteTask(Task task);

  FutureOr<dynamic> deleteAllTasks();

}