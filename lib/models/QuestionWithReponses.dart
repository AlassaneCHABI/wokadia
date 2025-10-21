import 'package:wokadia/models/reponse.dart';
import 'package:wokadia/models/question.dart';

class QuestionWithReponses {
  final Question question;
  final List<Reponse> reponses;

  QuestionWithReponses({
    required this.question,
    required this.reponses,
  });
}
