class Dictionary {
  Map _words = const {
    'discard': {'de': 'Verwerfen', 'en': 'Discard'},
    'chooseImperative': {'de': 'Wähle', 'en': 'Choose'},
    'a-male': {'de': 'einen', 'en': 'a'},
    'a-female': {'de': 'eine', 'en': 'a'},
    'a-neutral': {'de': 'ein', 'en': 'a'},
    'yes': {'de': 'Ja', 'en': 'Yes'},
    'no': {'de': 'Nein', 'en': 'No'},
    'few': {'de': 'wenige', 'en': 'few'},
    'some': {'de': 'einige', 'en': 'some'},
    'many': {'de': 'viele', 'en': 'many'},
    'done': {'de': 'Erledigt', 'en': 'Done'},
    'save': {'de': 'Speichern', 'en': 'Save'},
    'new': {'de': 'Neu', 'en': 'New'},
    'old': {'de': 'Alt', 'en': 'Old'},
    'delete': {'de': 'Löschen', 'en': 'Delete'},
    'reassign': {'de': 'Reaktivieren', 'en': 'Reassign'},
    'reason': {'de': 'Grund', 'en': 'Reason'},
    'tasks': {'de': 'Aufgaben', 'en': 'Tasks'},
    'addTask': {'de': 'Neue Aufgabe', 'en': 'Add Task'},
    'task': {'de': 'Aufgabe', 'en': 'Task'},
    'edit': {'de': 'Bearbeiten', 'en': 'Edit'},
    'more': {'de': 'Mehr', 'en': 'More'},
    'language': {'de': 'Sprache', 'en': 'Language'},
    'block': {'de': 'Sperrtag', 'en': 'Block'},
    'addBlock': {'de': 'Sperrtag(e) hinzufügen', 'en': 'Add Block(s)'},
    'blockImperative': {'de': 'Sperre', 'en': 'Block'},
    'list': {'de': 'Liste', 'en': 'List'},
    'circa': {'de': 'Circa', 'en': 'circa'},
    'circashort': {'de': 'ca.', 'en': 'approx.'},
    'deadline': {'de': 'Termin', 'en': 'Deadline'},
    'deadlines': {'de': 'Termine', 'en': 'Deadlines'},
    'date': {'de': 'Datum', 'en': 'Date'},
    'calendar': {'de': 'Kalender', 'en': 'Calendar'},
    'schedule': {'de': 'Planung', 'en': 'Schedule'},
    'mainmenu': {'de': 'Hauptmenü', 'en': 'Main Menu'},
    'today': {'de': 'Heute', 'en': 'Today'},
    'from': {'de': 'Von', 'en': 'From'},
    'to': {'de': 'Bis', 'en': 'To'},
    'tomorrow': {'de': 'Morgen', 'en': 'Tomorrow'},
    'day': {'de': 'Tag', 'en': 'day'},
    'days': {'de': 'Tage', 'en': 'days'},
    'and': {'de': 'und', 'en': 'and'},
    'time': {'de': 'Zeit', 'en': 'Time'},
    'timeInvestment': {'de': 'Zeitaufwand', 'en': 'Time Investment'},
    'minutes': {'de': 'Minuten', 'en': 'minutes'},
    'hour': {'de': 'Stunde', 'en': 'hour'},
    'hours': {'de': 'Stunden', 'en': 'hours'},
    'weeks': {'de': 'Wochen', 'en': 'weeks'},
    'month-s': {'de': 'Monat(e)', 'en': 'month(s)'},
    'remaining': {'de': 'übrig', 'en': 'remaining'},
    'name': {'de': 'Name', 'en': 'Name'},
    'description': {'de': 'Beschreibung', 'en': 'Description'},
    'priority': {'de': 'Priorität', 'en': 'Priority'},
    'low': {'de': 'Niedrig', 'en': 'low'},
    'standard': {'de': 'Standard', 'en': 'Standard'},
    'high': {'de': 'Hoch', 'en': 'high'},
    'very': {'de': 'sehr', 'en': 'very'},
    'welcome': {'de': 'Willkommen', 'en': 'Welcome'},
    'settings': {'de': 'Einstellungen', 'en': 'Settings'},
    'combine': {'de': 'Kombinieren', 'en': 'Combine'},
    'blockColor': {'de': 'Farbe Sperrtage', 'en': 'Block Color'},
    'deadlineColor': {'de': 'Farbe Termine', 'en': 'Deadline Color'},
    'todayColor': {
      'de': 'Farbe Tagesindikator',
      'en': 'Calendar\'s Today Color'
    },
  };

  Map _phrases = const {
    'dateIsBlocked': {
      'de': 'Dieser Tag wurde für Termine gesperrt!',
      'en': 'This date is blocked!'
    },
    'deleteBlock': {'de': 'Sperre aufheben', 'en': 'Delete Block'},
    'changeDate': {'de': 'Termin ändern', 'en': 'Change date'},
    'deleteBlockOrChangeDeadline': {
      'de':
          'Du kannst entweder die Sperre entfernen, oder ein anderes Datum wählen',
      'en': "You can either delete the block or change the Deadline"
    },
    'overwriteTitle': {
      'de': 'Bestehende Sperrtage überschreiben?',
      'en': 'Overwrite existing Blocks?'
    },
    'saveNew': {'de': 'Neue Speichern', 'en': 'Save New'},
    'keepOld': {'de': 'Bisheriges behalten', 'en': 'Keep Old'},
    'deadlineMissed': {'de': 'Termin verpasst', 'en': 'Deadline exceeded'},
    'nameFormFieldEmptyError': {
      'de': 'Bitte Namen eingeben',
      'en': 'Please enter name.'
    },
    'descrFormFieldEmptyError': {
      'de': 'Bitte Beschreibung kürzen',
      'en': 'Please shorten decription'
    },
    'blockMorePrompt': {
      'de': 'Mehr als ein Sperrtag?',
      'en': 'Block more than one day?'
    },
    'createTask': {'de': 'Aufgabe erstellen', 'en': 'Create Task'},
    'createDeadline': {'de': 'Termin eintragen', 'en': 'Create Deadline'},
    'editTask': {'de': 'Aufgabe bearbeiten', 'en': 'Edit Task'},
    'editDeadline': {'de': 'Termin bearbeiten', 'en': 'Edit Deadline'},
    'completedTasks': {'de': 'Erledigte Aufgaben', 'en': 'Completed Tasks'},
    'discardTaskTitle': {'de': 'Aufgabe verwerfen', 'en': 'Discard Task'},
    'discardTaskPrompt': {
      'de':
          'Sind Sie sicher, dass Sie diese Aufgabe vor der Vollendung verwerfen möchten?',
      'en': 'Are you sure to discard this Task without completion?'
    }
  };

  Map<String, Map<String, List<String>>> _collections = const {
    'months': {
      'de': [
        "Januar",
        "Februar",
        "März",
        "April",
        "Mai",
        "Juni",
        "Juli",
        "August",
        "September",
        "Oktober",
        "November",
        "Dezember",
      ],
      'en': [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
      ]
    },
    'shortDays': {
      'de': ["Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"],
      'en': ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    }
  };

  String displayWord(word, language) {
    return _words[word][language];
  }

  String displayPhrase(phrase, language) {
    return _phrases[phrase][language];
  }

  List displayCollection(collection, language) {
    return _collections[collection][language];
  }
}
