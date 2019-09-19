import 'package:scoped_model/scoped_model.dart';

import '../database/local-db.dart';
import '../globalSettings.dart';

mixin HelperModel on Model {
  String _activeTabRoute = "";
  String get activeTabRoute {
    return _activeTabRoute;
  }

  Settings settings = Settings();

  void setActiveTab({bool calendar, bool deadlines, bool tasks}) {
    if (calendar) {
      _activeTabRoute = "/calendar";
    }
    if (deadlines) {
      _activeTabRoute = "/deadlines";
    }
    if (tasks) {
      _activeTabRoute = "/tasks";
    }
    notifyListeners();
  }

  void querySettings() async {
    List<Map<String, dynamic>> sQuery = await LocalDB.db.querySettings();
    Map languageSetting = sQuery.firstWhere((setting) {
      return setting['identifier'] == 'language';
    });
    settings.language = languageSetting['identifier'];
  }
}
