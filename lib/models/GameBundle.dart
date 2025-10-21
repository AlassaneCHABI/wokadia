import 'package:wokadia/models/game.dart';
import 'package:wokadia/models/PhraseWithWords.dart';

class GameBundle {
  final Game game;
  final List<PhraseWithWords> phrases;

  GameBundle({required this.game, required this.phrases});
}