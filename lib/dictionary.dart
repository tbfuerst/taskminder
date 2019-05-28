class Dictionary {
  Map _texts = const {
    'tasks': {'de': 'Aufgaben', 'en': 'Tasks'},
    'deadlines': {'de': 'Fristen', 'en': 'Deadlines'},
    'calendar': {'de': 'Kalender', 'en': 'Calendar'},
    'schedule': {'de': 'Planung', 'en': 'Schedule'}
  };

  String display(word, language) {
    return _texts[word][language];
  }
}
