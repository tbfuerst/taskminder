class Dictionary {
  Map _words = const {
    'delete': {'de': 'Löschen', 'en': 'Delete'},
    'yes': {'de': 'Ja', 'en': 'Yes'},
    'no': {'de': 'Nein', 'en': 'No'},
    'tasks': {'de': 'Aufgaben', 'en': 'Tasks'},
    'deadlines': {'de': 'Fristen', 'en': 'Deadlines'},
    'calendar': {'de': 'Kalender', 'en': 'Calendar'},
    'schedule': {'de': 'Planung', 'en': 'Schedule'}
  };

  Map _phrases = const {
    'deleteTaskTitle': {'de': 'Aufgabe löschen', 'en': 'Delete Task'},
    'deleteTaskPrompt': {
      'de': 'Sind Sie sicher, dass Sie diese Aufgabe löschen möchten?',
      'en': 'Are you sure to delete this Task?'
    }
  };

  String displayWord(word, language) {
    return _words[word][language];
  }

  String displayPhrase(phrase, language) {
    return _phrases[phrase][language];
  }
}
