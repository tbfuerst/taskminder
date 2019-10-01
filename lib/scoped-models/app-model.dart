import 'package:scoped_model/scoped_model.dart';

import "../globalSettings.dart";
import '../database/local-db.dart';

mixin AppModel on Model {
  bool _isAppLoading = true;
  bool _firstStartup = true;

  bool get isAppLoading {
    return _isAppLoading;
  }

  bool get firstStartup {
    return _firstStartup;
  }

  void changeFirstStartupTo(bool to) {
    _firstStartup = to;
    notifyListeners();
  }

  void changeLoadingStateTo(bool to) {
    _isAppLoading = to;
    notifyListeners();
  }

  Settings settings = Settings();

  Future<bool> querySettings() async {
    List<Map<String, dynamic>> sQuery = await LocalDB.db.querySettings();
    if (sQuery.isNotEmpty) {
      settings.changeLanguage(sQuery[0]['language']);
      settings.changeFirstStartup(sQuery[0]['firstStartup']);
      settings.changeColors(sQuery[0]['blockColor'], sQuery[0]['deadlineColor'],
          sQuery[0]['dayIndicatorColor']);
      changeLoadingStateTo(false);
      notifyListeners();
      return true;
    } else {
      settings.changeLanguage("en");
      print("setting default language: english");
      changeLoadingStateTo(false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSettings(Settings newSettings) async {
    await LocalDB.db.updateSetting(newSettings.toMap());
    return true;
  }

  Future initializeSettings(String languageCode) async {
    Settings initSettings = Settings();
    initSettings.changeFirstStartup("false");
    await LocalDB.db.insertSetting(
      initSettings.toMap(),
    );

    _firstStartup = false;
    return;
  }
}
