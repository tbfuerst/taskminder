import 'package:scoped_model/scoped_model.dart';
import './helper-model.dart';
//import './task-model.dart';
import './deadline-model.dart';

// with keyword: mixin another class
// mixins in dart merges classes (their properties and methods)
class MainModel extends Model with DeadlineModel, HelperModel {}
//TaskModel {}
