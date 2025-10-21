import 'package:wokadia/models/phrase.dart';
import 'package:wokadia/models/word.dart';

class PhraseWithWords {
  final Phrase phrase;
  final List<Word> words;

  PhraseWithWords({required this.phrase, required this.words});
}