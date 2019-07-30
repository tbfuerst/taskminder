import 'package:scoped_model/scoped_model.dart';

mixin HelperModel on Model {
  int _navigatorPopsAfterTaskEdited;

  int get navigatorPopsAfterTaskEdited {
    return _navigatorPopsAfterTaskEdited;
  }

  set navigatorPopsAfterTaskEdited(int pops) {
    _navigatorPopsAfterTaskEdited = pops;
  }
}
