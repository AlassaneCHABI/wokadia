class Word {
  final int? id;
  final int onlineId;
  final int phraseId;
  final String word;
  final int isCorrect;
  final String slug;
  final String? instruction;

  Word({
    this.id,
    required this.onlineId,
    required this.phraseId,
    required this.word,
    required this.isCorrect,
    required this.slug,
    this.instruction,
  });

  factory Word.fromJson(Map<String, dynamic> json, int phraseId) => Word(
    onlineId: json['online_id'],
    phraseId: phraseId,
    word: json['word'],
    isCorrect: json['is_correct'],
    slug: json['slug'],
    instruction: json['instruction'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'online_id': onlineId,
    'phrase_id': phraseId,
    'word': word,
    'is_correct': isCorrect,
    'slug': slug,
    'instruction': instruction,
  };


  factory Word.fromMap(Map<String, dynamic> map) => Word(
    id: map['id'],
    onlineId: map['online_id'],
    phraseId: map['phrase_id'],
    word: map['word'],
    isCorrect: map['is_correct'],
    slug: map['slug'],
    instruction: map['instruction'],
  );


}