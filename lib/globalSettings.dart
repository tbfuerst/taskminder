class Settings {
  String _language = "en";
  bool _firstStartup = true;

  String get language {
    return _language;
  }

  bool get firstStartup {
    return _firstStartup;
  }

  changeLanguage(String languageCode) {
    _language = languageCode;
  }

  changeFirstStartup(String to) {
    if (to == "true") _firstStartup = true;
    if (to == "false") _firstStartup = false;
  }
}
