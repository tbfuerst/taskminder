class Dictionary {
  Map _words = const {
    'discard': {'de': 'Verwerfen', 'en': 'Discard'},
    'yes': {'de': 'Ja', 'en': 'Yes'},
    'no': {'de': 'Nein', 'en': 'No'},
    'tasks': {'de': 'Aufgaben', 'en': 'Tasks'},
    'deadlines': {'de': 'Fristen', 'en': 'Deadlines'},
    'calendar': {'de': 'Kalender', 'en': 'Calendar'},
    'schedule': {'de': 'Planung', 'en': 'Schedule'}
  };

  Map _phrases = const {
    'discardTaskTitle': {'de': 'Aufgabe verwerfen', 'en': 'Discard Task'},
    'discardTaskPrompt': {
      'de':
          'Sind Sie sicher, dass Sie diese Aufgabe vor der Vollendung verwerfen möchten?',
      'en': 'Are you sure to discard this Task without completion?'
    }
  };

  String displayWord(word, language) {
    return _words[word][language];
  }

  String displayPhrase(phrase, language) {
    return _phrases[phrase][language];
  }
}
