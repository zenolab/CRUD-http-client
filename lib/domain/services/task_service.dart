import 'dart:async';
import 'package:crud_http_client/domain/models/task.dart';

import 'base/base_services.dart';

mixin  BaseTaskService implements BaseService {
  Future<Task> getTask(Task task);

  Future<List<Task>> getAllTasks();

  FutureOr<dynamic> createTask(Task task);

  FutureOr<dynamic> updateTask(Task task);

  FutureOr<dynamic> deleteTask(Task task);

  FutureOr<dynamic> deleteAllTasks();
}
