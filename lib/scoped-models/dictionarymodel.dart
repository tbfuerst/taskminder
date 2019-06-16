import 'package:scoped_model/scoped_model.dart';

import '../models/dictionary.dart';

mixin DictionaryModel on Model {
  Dictionary _dictionary = Dictionary();

  Dictionary getDict() {
    return _dictionary;
  }
}
