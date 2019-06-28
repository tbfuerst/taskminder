class Dictionary {
  Map _words = const {
    'discard': {'de': 'Verwerfen', 'en': 'Discard'},
    'yes': {'de': 'Ja', 'en': 'Yes'},
    'no': {'de': 'Nein', 'en': 'No'},
    'few': {'de': 'wenige', 'en': 'few'},
    'some': {'de': 'einige', 'en': 'some'},
    'many': {'de': 'viele', 'en': 'many'},
    'done': {'de': 'Erledigt', 'en': 'Done'},
    'reassign': {'de': 'Reaktivieren', 'en': 'Reassign'},
    'tasks': {'de': 'Aufgaben', 'en': 'Tasks'},
    'task': {'de': 'Aufgabe', 'en': 'Task'},
    'edit': {'de': 'Bearbeiten', 'en': 'Edit'},
    'deadline': {'de': 'Termin', 'en': 'Deadline'},
    'deadlines': {'de': 'Termine', 'en': 'Deadlines'},
    'calendar': {'de': 'Kalender', 'en': 'Calendar'},
    'schedule': {'de': 'Planung', 'en': 'Schedule'},
    'mainmenu': {'de': 'Hauptmenü', 'en': 'Main Menu'},
    'day': {'de': 'Tag', 'en': 'day'},
    'days': {'de': 'Tage', 'en': 'days'},
    'and': {'de': 'und', 'en': 'and'},
    'minutes': {'de': 'Minuten', 'en': 'minutes'},
    'hour': {'de': 'Stunde', 'en': 'hour'},
    'hours': {'de': 'Stunden', 'en': 'hours'},
    'weeks': {'de': 'Wochen', 'en': 'weeks'},
    'month-s': {'de': 'Monat(e)', 'en': 'month(s)'},
    'remaining': {'de': 'übrig', 'en': 'remaining'},
  };

  Map _phrases = const {
    'completedTasks': {'de': 'Erledigte Aufgaben', 'en': 'Completed Tasks'},
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
