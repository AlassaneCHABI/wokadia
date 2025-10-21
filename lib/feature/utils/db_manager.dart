import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:wokadia/models/exercice.dart';
import 'package:wokadia/models/game.dart';
import 'package:wokadia/models/QuestionWithReponses.dart';
import 'package:wokadia/models/SelectedModule.dart';
import 'package:wokadia/models/chapitres.dart';
import 'package:wokadia/models/commune.dart';
import 'package:wokadia/models/domaines.dart';
import 'package:wokadia/models/eleve.dart';
import 'package:wokadia/models/historiqueFormation.dart';
import 'package:wokadia/models/historiqueQcm.dart';
import 'package:wokadia/models/historique_module.dart';
import 'package:wokadia/models/historique_programme.dart';
import 'package:wokadia/models/modules.dart';

import 'package:wokadia/models/organisations.dart';
import 'package:wokadia/models/pays.dart';
import 'package:wokadia/models/phrase.dart';
import 'package:wokadia/models/programme.dart';
import 'package:wokadia/models/reponse.dart';
import 'package:wokadia/models/role.dart';
import 'package:wokadia/models/sousChapitre.dart';
import 'package:wokadia/models/users.dart';
import 'package:wokadia/models/word.dart';
import 'package:wokadia/models/question.dart';

import '../../models/selectedProgramme.dart';

class DbManager {
  static String dbName = "wokadia.db";
  static int dbVersion = 1;


  static Future<Database> db() async {
    var databasesPath = await getDatabasesPath();
    return openDatabase(
      join(databasesPath, dbName),
      version: dbVersion,
      onCreate: (Database database, int version) async {
        /*print("********onCreate VERSION");
        print(version);*/
        await createTables(database);
      },
      onUpgrade: (Database database, int oldVersion, int newVersion) async {

      },
    );
  }


  static createTables(Database database) async {
    try {
      var table_user = "CREATE TABLE IF NOT EXISTS users"
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "online_id INTEGER,"
          "role_id INTEGER,"
          "organisation_id INTEGER,"
          "role_name TEXT,"
          "organisation_name TEXT,"
          "pays TEXT,"
          "commune TEXT,"
          "name TEXT,"
          "email TEXT,"
          "contact TEXT,"
          "sexe TEXT,"
          "status TEXT,"
          "password TEXT,"
          "path_photo TEXT,"
          "created_at TEXT,"
          "slug TEXT)";

      var table_organisation = "CREATE TABLE IF NOT EXISTS organisations"
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "online_id INTEGER,"
          "abonnement_id INTEGER,"
          "abonnement_name TEXT NULL,"
          "name TEXT NULL,"
          "type_organise TEXT NULL,"
          "ifu TEXT NULL,"
          "contact TEXT NULL,"
          "email TEXT NULL,"
          "adresse TEXT NULL,"
          "responsable TEXT NULL,"
          "nb_utilisateurs_max INTEGER,"
          "description TEXT NULL,"
          "created_at TEXT NULL,"
          "slug TEXT)";

      var tableModules = """
        CREATE TABLE IF NOT EXISTS modules (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          online_id INTEGER,
          domaine_id INTEGER,
          name TEXT,
          domaine_name TEXT,
          description TEXT,
          module_icon TEXT,
          localIconPath TEXT,
          slug TEXT,
          statut TEXT,
          domaine_code TEXT
        );
        """;

      var tableselected_modules  = """
        CREATE TABLE IF NOT EXISTS selected_modules (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          module_id INTEGER,
          domaine_id INTEGER,
          name TEXT NULL,
          domaine_name TEXT NULL,
          description TEXT NULL,
          domaine_code TEXT NULL,
          localIconPath  TEXT NULL,
          score INTEGER NULL,
          isDone INTEGER NULL,
          totalTime INTEGER NULL
        );
        """;

      var tableDomaines = """
          CREATE TABLE IF NOT EXISTS domaines (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            online_id INTEGER,
            name TEXT,
            detail TEXT,
            domaine_code TEXT,
            domaine_icon TEXT
          );
          """;

      var table_chapitre = "CREATE TABLE IF NOT EXISTS chapitres ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "online_id INTEGER,"
          "module_id INTEGER,"
          "titre TEXT NULL,"
          "description TEXT NULL,"
          "images TEXT NULL,"
          "slug TEXT,"
          "is_done INTEGER DEFAULT 0"
          ")";


      var table_exercice = "CREATE TABLE IF NOT EXISTS exercices"
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "online_id INTEGER,"
          "programme_id INTEGER,"
          "programme_name TEXT NULL,"
          "name TEXT NULL,"
          "duration_seconds INTEGER,"
          "exercise_icon TEXT NULL,"
          "instruction  TEXT)";

      final String tableGames = '''
        CREATE TABLE IF NOT EXISTS games (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          online_id INTEGER,
          name TEXT,
          game_icon TEXT,
          local_icon_path TEXT,
          isDone INTEGER DEFAULT 0
        )
      ''';


      // table_phrases
      final String tablePhrases = '''
          CREATE TABLE IF NOT EXISTS phrases (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            online_id INTEGER,
            game_id INTEGER,
            name TEXT,
            game_name TEXT,
            FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
          )
        ''';

        // table_words
              final String tableWords = '''
          CREATE TABLE IF NOT EXISTS words (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            online_id INTEGER,
            phrase_id INTEGER,
            word TEXT,
            is_correct INTEGER,
            slug TEXT,
            instruction TEXT,
            FOREIGN KEY (phrase_id) REFERENCES phrases(id) ON DELETE CASCADE
          )
        ''';


      var table_historique_formation = "CREATE TABLE IF NOT EXISTS historique_formations"
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "online_id INTEGER,"
          "user_id INTEGER,"
          "module_id INTEGER,"
          "module_name TEXT NULL,"
          "date_debut TEXT NULL,"
          "date_fin TEXT NULL,"
          "score TEXT NULL,"
          "temps_total TEXT NULL,"
          "created_at TEXT NULL,"
          "slug TEXT)";

      var table_historique_qcm = "CREATE TABLE IF NOT EXISTS historique_qcm"
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "online_id INTEGER,"
          "user_id INTEGER,"
          "question_id INTEGER,"
          "question_name TEXT NULL,"
          "date TEXT NULL,"
          "score TEXT NULL,"
          "temps_total TEXT NULL,"
          "created_at TEXT NULL,"
          "slug TEXT)";

      var table_programme = "CREATE TABLE IF NOT EXISTS programmes"
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "online_id INTEGER,"
          "name TEXT NULL,"
          "programme_icon  TEXT NULL,"
          "isDone  TEXT NULL,"
          "duration TEXT)";

      var table_selected_programmes  = "CREATE TABLE IF NOT EXISTS selected_programmes "
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "programme_id INTEGER,"
          "name TEXT NULL,"
          "programme_icon  TEXT NULL,"
          "isDone  TEXT NULL,"
          "duration TEXT)";

      var table_questions = '''
          CREATE TABLE IF NOT EXISTS questions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            online_id INTEGER,
            module_id INTEGER,
            titre TEXT,
            type TEXT,
            active INTEGER,
            slug TEXT
          )
          ''';


      var table_reponse = "CREATE TABLE IF NOT EXISTS reponses"
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "online_id INTEGER,"
          "question_id INTEGER,"
          "texte TEXT NULL,"
          "correct INTEGER DEFAULT 0,"
          "slug TEXT)";

      var table_role = "CREATE TABLE IF NOT EXISTS roles"
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "online_id INTEGER,"
          "name TEXT NULL,"
          "description TEXT NULL,"
          "created_at TEXT NULL,"
          "slug TEXT)";

      var table_sous_chapitre = "CREATE TABLE IF NOT EXISTS sous_chapitres"
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "online_id INTEGER,"
          "chapitre_id INTEGER,"
          "chapitre_name TEXT NULL,"
          "titre TEXT NULL,"
          "description TEXT NULL,"
          "ordre TEXT NULL,"
          "image TEXT NULL,"
          "created_at TEXT NULL,"
          "slug TEXT)";



      var table_pays = "CREATE TABLE IF NOT EXISTS pays"
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "online_id INTEGER,"
          "pays_name TEXT NULL,"
          "code TEXT)";

      var table_commune = "CREATE TABLE IF NOT EXISTS communes"
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "online_id INTEGER,"
          "pays_id INTEGER,"
          "pays_name TEXT NULL,"
          "commune_name TEXT NULL,"
          "code TEXT)";

      var table_eleve = "CREATE TABLE IF NOT EXISTS eleves"
                "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
                "user_id  INTEGER,"
                "nom TEXT NULL,"
                "ville TEXT NULL,"
                "ecole TEXT NULL,"
                "classe TEXT NULL,"
                "photo TEXT NULL,"
                "sexe  TEXT NULL,"
                "centre TEXT)";

      var table_historique_module = "CREATE TABLE IF NOT EXISTS historiqueModules"
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "user_id  INTEGER,"
          "module_id   INTEGER,"
          "user_name TEXT NULL,"
          "module_name  TEXT NULL,"
          "centre   TEXT NULL,"
          "temps_total  TEXT NULL,"
          "date  TEXT NULL,"
          "score  INTEGER DEFAULT 0,"
          "nombre_total_eleve  INTEGER DEFAULT 0)";

      var table_historique_programme = "CREATE TABLE IF NOT EXISTS historiqueProgramme"
          "(id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "user_id  INTEGER,"
          "programme_id   INTEGER,"
          "user_name TEXT NULL,"
          "programme_name  TEXT NULL,"
          "centre   TEXT NULL,"
          "temps_total  TEXT NULL,"
          "date  TEXT NULL,"
          "nombre_total_eleve  INTEGER DEFAULT 0)";

      await database.execute(table_user);
      await database.execute(table_organisation);
      await database.execute(tableModules);
      await database.execute(tableDomaines);
      await database.execute(table_chapitre);
      await database.execute(table_exercice);
      await database.execute(tableGames);
      await database.execute(table_historique_formation);
      await database.execute(table_historique_qcm);
      await database.execute(tablePhrases );
      await database.execute(table_programme);
      await database.execute(table_questions);
      await database.execute(table_reponse);
      await database.execute(table_role);
      await database.execute(table_sous_chapitre);
      await database.execute(tableWords );
      await database.execute(table_pays);
      await database.execute(table_commune);
      await database.execute(table_eleve);
      await database.execute(tableselected_modules);
      await database.execute(table_selected_programmes);
      await database.execute(table_historique_module);
      await database.execute(table_historique_programme);
    }catch(e){

      print("******* Erreur création tables");
      print(e);
    }
  }


/*------------ User-----------------*/

  Future<int?> insertDbUser(User item) async {
    int? resultat;
    final db = await DbManager.db();
    final data = {
      'id': item.id,
      'online_id': item.online_id,
      'role_id': item.role_id,
      'organisation_id': item.organisation_id,
      'role_name': item.role_name,
      'organisation_name': item.organisation_name,
      'pays': item.pays,
      'commune': item.commune,
      'name': item.name,
      'email': item.email,
      'contact': item.contact,
      'sexe': item.sexe,
      'status': item.status,
      'password': item.password,
      'path_photo': item.path_photo,
      'created_at': item.created_at,
      'slug': item.slug,
    };
    resultat = await db.insert(
      'users',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return resultat;
  }

  Future<List<User>> getAllDbUser() async {
    final db = await DbManager.db();
    List<Map<String, Object?>> liste = await db.query('users');
    List<User> items = liste.map((element) => User.fromJson(element)).toList();
    return items;
  }

  Future<User?> getDbUser(String item_slug) async {
    final db = await DbManager.db();
    List<Map<String, dynamic>> liste = await db.query(
      'users',
      where: "slug = ?",
      whereArgs: [item_slug],
      limit: 1,
    );
    List<User> items = liste.map((element) => User.fromJson(element)).toList();
    return items.isNotEmpty ? items.first : null;
  }

  Future<User?> getUser() async {
    final db = await DbManager.db();
    List<Map<String, dynamic>> liste = await db.query('users', limit: 1);

    if (liste.isNotEmpty) {
      List<User> items = liste.map((element) => User.fromJson(element)).toList();
      return items.first;
    } else {
      return null; // tu peux aussi lever une exception comme avant
    }
  }

  Future<int?> updateDbUser(User item) async {
    int? resultat;
    final db = await DbManager.db();
    final data = {
      'online_id': item.online_id,
      'role_id': item.role_id,
      'organisation_id': item.organisation_id,
      'role_name': item.role_name,
      'organisation_name': item.organisation_name,
      'pays': item.pays,
      'commune': item.commune,
      'name': item.name,
      'email': item.email,
      'contact': item.contact,
      'sexe': item.sexe,
      'status': item.status,
      'password': item.password,
      'path_photo': item.path_photo,
      'created_at': item.created_at,
      'slug': item.slug,
    };

    resultat = await db.update(
      'users',
      data,
      where: "slug = ?",
      whereArgs: [item.slug],
    );
    return resultat;
  }

  Future<int?> countDbUser() async {
    final db = await DbManager.db();
    final comptage = await db.rawQuery('SELECT COUNT(*) FROM users');
    int? compte = Sqflite.firstIntValue(comptage);
    return compte;
  }

  Future<void> updatePassword(String email, String newPassword) async {
    final db = await DbManager.db();
    await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<void> removeDbUser(String item_slug) async {
    final db = await DbManager.db();
    await db.delete(
      "users",
      where: "slug = ?",
      whereArgs: [item_slug],
    );
  }

  Future<void> removeAllDbUser() async {
    final db = await DbManager.db();
    await db.delete("users");
  }

//------------- organisation----------

  // INSERT
  Future<int?> insertDbOrganisation(Organisations orga) async {
    final db = await DbManager.db();
    return await db.insert(
      'organisations',
      orga.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// GET ALL
  Future<List<Organisations>> getAllDbOrganisations() async {
    final db = await DbManager.db();
    final data = await db.query('organisations');
    return data.map((json) => Organisations.fromJson(json)).toList();
  }

// GET BY online_id
  Future<Organisations?> getDbOrganisation(int onlineId) async {
    final db = await DbManager.db();
    final data = await db.query(
      'organisations',
      where: "online_id = ?",
      whereArgs: [onlineId],
      limit: 1,
    );
    if (data.isNotEmpty) {
      return Organisations.fromJson(data.first);
    }
    return null;
  }

// UPDATE
  Future<int?> updateDbOrganisation(Organisations orga) async {
    final db = await DbManager.db();
    return await db.update(
      'organisations',
      orga.toJson(),
      where: "online_id = ?",
      whereArgs: [orga.online_id],
    );
  }

// DELETE BY online_id
  Future<void> removeDbOrganisation(int onlineId) async {
    final db = await DbManager.db();
    await db.delete("organisations", where: "online_id = ?", whereArgs: [onlineId]);
  }

// DELETE ALL
  Future<void> removeAllDbOrganisations() async {
    final db = await DbManager.db();
    await db.rawDelete('DELETE FROM organisations');
  }

// COUNT
  Future<int?> countDbOrganisations() async {
    final db = await DbManager.db();
    final result = await db.rawQuery('SELECT COUNT(*) FROM organisations');
    return Sqflite.firstIntValue(result);
  }



  // -----------modules----------------

  // Modules
  Future<int?> insertDbModule(Modules module) async {
    final db = await DbManager.db();
    return await db.insert('modules', module.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Modules>> getModulesByDomaineId(int domaineId) async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query(
      'modules',
      where: 'domaine_id = ?',
      whereArgs: [domaineId],
    );
    return maps.map((e) => Modules.fromJson(e, domaineId)).toList();
  }

  Future<void> removeAllDbModules() async {
    final db = await DbManager.db();
    await db.delete('modules');
  }


  //------------Domaine------------

  // Domaines
  Future<int?> insertDbDomaine(Domaines domaine) async {
    final db = await DbManager.db();
    return await db.insert('domaines', domaine.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Domaines>> getAllDbDomaines() async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query('domaines');
    return maps.map((e) => Domaines.fromJson(e)).toList();
  }

  Future<void> removeAllDbDomaines() async {
    final db = await DbManager.db();
    await db.delete('domaines');
  }

  Future<List<int>> getAllDomainOnlineIds() async {
    final db = await DbManager.db();
    final result = await db.rawQuery('SELECT online_id FROM domaines');
    return result.map((e) => e['online_id'] as int).toList();
  }

  Future<List<int>> getAllModuleOnlineIds() async {
    final db = await DbManager.db();
    final result = await db.rawQuery('SELECT online_id FROM modules');
    return result.map((e) => e['online_id'] as int).toList();
  }


  /*Future<int> insertDbDomaineWithTxn(DatabaseExecutor txn, Domaines domaine) async {
    return await txn.insert(
      'domaines',
      domaine.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertDbModuleWithTxn(DatabaseExecutor txn, Modules module) async {
    return await txn.insert(
      'modules',
      module.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
*/

  Future<Domaines?> getDomaineByOnlineId(int onlineId) async {
    final db = await DbManager.db();
    final maps = await db.query('domaines', where: 'online_id = ?', whereArgs: [onlineId]);

    if (maps.isNotEmpty) {
      final d = maps.first;
      return Domaines(
        d['id'] is int ? d['id'] as int : int.tryParse(d['id'].toString()) ?? 0,
        d['online_id'] is int ? d['online_id'] as int : int.tryParse(d['online_id'].toString()) ?? 0,
        d['name']?.toString() ?? '',
        d['detail']?.toString() ?? '',
        d['domaine_code']?.toString() ?? '',
        d['domaine_icon']?.toString() ?? '',
      );
    }
    return null;
  }

  Future<Modules?> getModuleByOnlineId(int onlineId) async {
    final db = await DbManager.db();
    final maps = await db.query('modules', where: 'online_id = ?', whereArgs: [onlineId]);

    if (maps.isNotEmpty) {
      final m = maps.first;
      return Modules(
        m['id'] is int ? m['id'] as int : int.tryParse(m['id'].toString()) ?? 0,
        m['online_id'] is int ? m['online_id'] as int : int.tryParse(m['online_id'].toString()) ?? 0,
        m['domaine_id'] is int ? m['domaine_id'] as int : int.tryParse(m['domaine_id'].toString()) ?? 0,
        m['name']?.toString() ?? '',
        m['domaine_name']?.toString() ?? '',
        m['description']?.toString() ?? '',
        m['module_icon']?.toString() ?? '',
        m['slug']?.toString() ?? '',
        m['statut']?.toString() ?? '',
        m['domaine_code']?.toString() ?? '',
        m['localIconPath']?.toString(),
      );
    }
    return null;
  }


  Future<int> insertDbDomaineWithTxn(DatabaseExecutor txn, Domaines domaine) async {
    return await txn.insert('domaines', domaine.toJson());
  }

  Future<int> insertDbModuleWithTxn(DatabaseExecutor txn, Modules module) async {
    return await txn.insert('modules', module.toJson());
  }





  // ------------------------chapitre-------------------------

// 🔹 Insert
  Future<int> insertChapitre(Chapitre chapitre) async {
    final db = await DbManager.db();
    return await db.insert(
      'chapitres',
      chapitre.toMap(), // ✅ utilise le toMap() avec jsonEncode(images)
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// 🔹 Get all
  Future<List<Chapitre>> getAllChapitres() async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query('chapitres');
    return maps.map((map) => Chapitre.fromMap(map)).toList(); // ✅ decode JSON
  }

// 🔹 Get by module_id
  Future<List<Chapitre>> getChapitresByModule(int moduleId) async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query(
      'chapitres',
      where: 'module_id = ?',
      whereArgs: [moduleId],
    );
    return maps.map((map) => Chapitre.fromMap(map)).toList(); // ✅ decode JSON
  }

  // 🔹 Get by module_id
  Future<List<Chapitre>> getChapitresById(int chapitre_id) async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query(
      'chapitres',
      where: 'id = ?',
      whereArgs: [chapitre_id],
    );
    return maps.map((map) => Chapitre.fromMap(map)).toList(); // ✅ decode JSON
  }

// 🔹 Update
  Future<int> updateChapitre(Chapitre chapitre) async {
    final db = await DbManager.db();
    return await db.update(
      'chapitres',
      chapitre.toMap(), // ✅ encode JSON
      where: 'id = ?',
      whereArgs: [chapitre.id],
    );
  }

// 🔹 Delete
  Future<int> deleteChapitre(int id) async {
    final db = await DbManager.db();
    return await db.delete(
      'chapitres',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// 🔹 Delete All
  Future<void> clearAllChapitres() async {
    final db = await DbManager.db();
    await db.delete('chapitres');
  }

// 🔹 Count
  Future<int?> countDbChapitres() async {
    final db = await DbManager.db();
    final comptage = await db.rawQuery('SELECT COUNT(*) FROM chapitres');
    return Sqflite.firstIntValue(comptage);
  }

  Future<int> markChapitreAsDone(int id, bool isDone) async {
    final db = await DbManager.db();
    return await db.update(
      'chapitres',
      {'is_done': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }





// ---------- GAMES ----------
  Future<int> insertGame(Game game) async {
    final db = await DbManager.db();
    return await db.insert('games', game.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Game>> getGames() async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query('games');

    return List.generate(maps.length, (i) => Game(
      id: maps[i]['id'],
      onlineId: maps[i]['online_id'],
      name: maps[i]['name'],
      gameIcon: maps[i]['game_icon'],
      localIconPath: maps[i]['local_icon_path'],
      isDone: maps[i]['isDone']==0?false:true, // ✅ valeur par défaut si null
    ));
  }



  Future<void> updateGame(int gameid) async {
    final db = await DbManager.db();

    await db.update(
      'games',
      {'isDone': 1}, // stocke le score sous forme de string comme dans ton modèle
      where: 'online_id = ?',
      whereArgs: [gameid],
    );
  }


  /// Récupère toutes les phrases et leurs words pour un game donné
  Future<List<Phrase>> getPhrasesByGame(int gameId) async {
    // 1️⃣ Récupérer les phrases du game
    final db = await DbManager.db();
    final phraseMaps = await db.query(
      'phrases',
      where: 'game_id = ?',
      whereArgs: [gameId],
    );

    List<Phrase> phrases = [];

    for (var p in phraseMaps) {
      // 2️⃣ Récupérer les mots liés à cette phrase
      final wordMaps = await db.query(
        'words',
        where: 'phrase_id = ?',
        whereArgs: [p['id']],
      );

      List<Word> words = wordMaps.map((w) {
        return Word(
          id: w['id'] as int,
          onlineId: w['online_id'] as int,
          phraseId: w['phrase_id'] as int,
          word: w['word'] as String,
          isCorrect: w['is_correct'] as int,
          slug: w['slug'] as String,
          instruction: w['instruction'] as String?,
        );
      }).toList();

      phrases.add(
        Phrase(
          id: p['id'] as int,
          onlineId: p['online_id'] as int,
          gameId: p['game_id'] as int,
          name: p['name'] as String,
          gameName: p['game_name'] as String,
        ),
      );
    }

    return phrases;
  }


  Future<void> removeAllGames() async{
    final db = await DbManager.db();
    await db.delete('games');
  }



  // ---------- PHRASES ----------
  Future<int> insertPhrase(Phrase phrase) async {
    final db = await DbManager.db();
    return await db.insert('phrases', phrase.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Phrase>> getPhrases(int gameId) async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps =
    await db.query('phrases', where: 'game_id = ?', whereArgs: [gameId]);
    return List.generate(maps.length, (i) => Phrase(
      id: maps[i]['id'],
      onlineId: maps[i]['online_id'],
      gameId: maps[i]['game_id'],
      name: maps[i]['name'],
      gameName: maps[i]['game_name'],
    ));
  }

  Future<void> removeAllPhrases() async {
    final db = await DbManager.db();
    await db.delete('phrases');
  }

  // ---------- WORDS ----------
  Future<int> insertWord(Word word) async {
    final db = await DbManager.db();
    return await db.insert('words', word.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Word>> getWords(int phraseId) async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps =
    await db.query('words', where: 'phrase_id = ?', whereArgs: [phraseId]);
    return List.generate(maps.length, (i) => Word(
      id: maps[i]['id'],
      onlineId: maps[i]['online_id'],
      phraseId: maps[i]['phrase_id'],
      word: maps[i]['word'],
      isCorrect: maps[i]['is_correct'],
      slug: maps[i]['slug'],
      instruction: maps[i]['instruction'],
    ));
  }



  Future<List<Word>> getWordsByPhrase(int phraseId) async {
    final db = await DbManager.db();
    final maps =
    await db.query('words', where: 'phrase_id = ?', whereArgs: [phraseId]);
    return List.generate(maps.length, (i) => Word.fromMap(maps[i]));
  }

  Future<void> removeAllWords() async {
    final db = await DbManager.db();
    await db.delete('words');
  }






  // ➡️ Insert
  Future<int?> insertDbHistoriqueFormation(HistoriqueFormation hf) async {
    final db = await DbManager.db();
    return await db.insert(
      'historique_formations',
      hf.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// ➡️ Get all
  Future<List<HistoriqueFormation>> getAllDbHistoriqueFormation() async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> data = await db.query('historique_formations');
    return data.map((json) => HistoriqueFormation.fromJson(json)).toList();
  }

// ➡️ Get one by slug
  Future<HistoriqueFormation?> getDbHistoriqueFormation(String slug) async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> data = await db.query(
      'historique_formations',
      where: "slug = ?",
      whereArgs: [slug],
      limit: 1,
    );
    if (data.isNotEmpty) {
      return HistoriqueFormation.fromJson(data.first);
    }
    return null;
  }

// ➡️ Update
  Future<int?> updateDbHistoriqueFormation(HistoriqueFormation hf) async {
    final db = await DbManager.db();
    return await db.update(
      'historique_formations',
      hf.toJson(),
      where: "slug = ?",
      whereArgs: [hf.slug],
    );
  }

// ➡️ Delete one
  Future<void> removeDbHistoriqueFormation(String slug) async {
    final db = await DbManager.db();
    await db.delete("historique_formations", where: "slug = ?", whereArgs: [slug]);
  }

// ➡️ Delete all
  Future<void> removeAllDbHistoriqueFormation() async {
    final db = await DbManager.db();
    await db.rawDelete('DELETE FROM historique_formations');
  }

// ➡️ Count
  Future<int?> countDbHistoriqueFormation() async {
    final db = await DbManager.db();
    final result = await db.rawQuery('SELECT COUNT(*) FROM historique_formations');
    return Sqflite.firstIntValue(result);
  }



  Future<int?> insertDbHistoriqueQCM(HistoriqueQcm hqcm) async {
    final db = await DbManager.db();
    return await db.insert('historique_qcm', hqcm.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<HistoriqueQcm>> getAllDbHistoriqueQCM() async {
    final db = await DbManager.db();
    final data = await db.query('historique_qcm');
    return data.map((json) => HistoriqueQcm.fromJson(json)).toList();
  }

  Future<HistoriqueQcm?> getDbHistoriqueQCM(int onlineId) async {
    final db = await DbManager.db();
    final data = await db.query('historique_qcm', where: "online_id = ?", whereArgs: [onlineId], limit: 1);
    if (data.isNotEmpty) return HistoriqueQcm.fromJson(data.first);
    return null;
  }

  Future<int?> updateDbHistoriqueQCM(HistoriqueQcm hqcm) async {
    final db = await DbManager.db();
    return await db.update('historique_qcm', hqcm.toJson(), where: "online_id = ?", whereArgs: [hqcm.online_id]);
  }

  Future<void> removeDbHistoriqueQCM(int onlineId) async {
    final db = await DbManager.db();
    await db.delete("historique_qcm", where: "online_id = ?", whereArgs: [onlineId]);
  }

  Future<void> removeAllDbHistoriqueQCM() async {
    final db = await DbManager.db();
    await db.rawDelete('DELETE FROM historique_qcm');
  }

  Future<int?> countDbHistoriqueQCM() async {
    final db = await DbManager.db();
    final result = await db.rawQuery('SELECT COUNT(*) FROM historique_qcm');
    return Sqflite.firstIntValue(result);
  }





  Future<int> insertProgramme(Programme programme) async {
    final db = await DbManager.db();
    return await db.insert('programmes', programme.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Programme>> getAllProgrammes() async {
    final db = await DbManager.db();
    final maps = await db.query('programmes');
    return List.generate(maps.length, (i) => Programme.fromMap(maps[i]));
  }

  Future<int> updateProgramme(Programme programme) async {
    final db = await DbManager.db();
    return await db.update(
      'programmes',
      programme.toMap(),
      where: 'online_id = ?',
      whereArgs: [programme.id],
    );
  }

  Future<Programme?> getProgrammeById(int id) async {
    final db = await DbManager.db();
    final result = await db.query(
      'programmes',
      where: 'online_id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Programme.fromMap(result.first);
    }
    return null;
  }


  Future<int> deleteProgramme(int id) async {
    final db = await DbManager.db();
    return await db.delete('programmes', where: 'online_id = ?', whereArgs: [id]);
  }

  Future<void> removeAllProgrammes() async {
    final db = await DbManager.db();
    await db.delete('programmes');
  }

  Future<bool> allProgrammeDone() async {
    final db = await DbManager.db();
    final result = await db.rawQuery('SELECT COUNT(*) as total, SUM(isDone) as done FROM selected_programmes');

    if (result.isNotEmpty) {
      int total = result.first['total'] as int;
      int done = result.first['done'] as int? ?? 0;
      return total > 0 && total == done; // tous validés
    }
    return false;
  }

  Future<void> updateProgrammeScore(int programmeId) async {
    final db = await DbManager.db();

    await db.update(
      'programmes',
      {'isDone': 1}, // stocke le score sous forme de string comme dans ton modèle
      where: 'online_id = ?',
      whereArgs: [programmeId],
    );
  }

  Future<void> updateSelectedProgramme(int programmeId,int duration) async {
    final db = await DbManager.db();

    await db.update(
      'selected_programmes',
      {'isDone': 1,
      'duration': duration
      }, // stocke le score sous forme de string comme dans ton modèle
      where: 'programme_id = ?',
      whereArgs: [programmeId],
    );
  }



  // === Selected Programmes CRUD ===
  Future<int> insertSelectedProgramme(SelectedProgramme sp) async {
    final db = await DbManager.db();
    return await db.insert(
      'selected_programmes',
      sp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SelectedProgramme>> getAllSelectedProgrammes() async {
    final db = await DbManager.db();
    final maps = await db.query('selected_programmes');
    return List.generate(maps.length, (i) => SelectedProgramme.fromMap(maps[i]));
  }

  Future<int> deleteSelectedProgramme(int id) async {
    final db = await DbManager.db();
    return await db.delete('selected_programmes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> removeAllSelectedProgrammes() async {
    final db = await DbManager.db();
    await db.delete('selected_programmes');
  }


  Future<bool> programmeExists(int programmeId) async {
    final db = await DbManager.db();
    final result = await db.query(
      'selected_programmes',
      where: 'programme_id = ?',
      whereArgs: [programmeId],
      limit: 1, // on ne veut qu'une seule ligne
    );
    return result.isNotEmpty;
  }


// ---------------- Exercice----------------

  Future<int> insertExercise(Exercice exercise) async {
    final db = await DbManager.db();
    return await db.insert('exercices', exercise.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Exercice>> getExercisesByProgramme(int programmeId) async {
    final db = await DbManager.db();
    final maps = await db.query(
      'exercices',
      where: 'programme_id = ?',
      whereArgs: [programmeId],
    );
    return List.generate(maps.length, (i) => Exercice.fromMap(maps[i]));
  }

  Future<int> updateExercise(Exercice exercise) async {
    final db = await DbManager.db();
    return await db.update(
      'exercices',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<int> deleteExercise(int id) async {
    final db = await DbManager.db();
    return await db.delete('exercices', where: 'id = ?', whereArgs: [id]);
  }

  // ➡️ Delete all
  Future<void> removeAllExercises() async {
    final db = await DbManager.db();
    await db.rawDelete('DELETE FROM exercices');
  }

// ➡️ Count
  Future<int?> countDbExercices() async {
    final db = await DbManager.db();
    final comptage = await db.rawQuery('SELECT COUNT(*) FROM exercices');
    return Sqflite.firstIntValue(comptage);
  }



// ---------------- Questions CRUD ----------------

  Future<int> insertQuestion(Question q) async {
    final dbClient = await db();
    return await dbClient.insert('questions', q.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateQuestion(Question q) async {
    final dbClient = await db();
    return await dbClient.update(
      'questions',
      q.toMap(),
      where: 'id = ?',
      whereArgs: [q.id],
    );
  }

  Future<int> deleteQuestion(int id) async {
    final dbClient = await db();
    await dbClient.delete('reponses', where: 'question_id = ?', whereArgs: [id]);
    return await dbClient.delete('questions', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Question>> getAllQuestions() async {
    final dbClient = await db();
    final maps = await dbClient.query('questions');
    return maps.map((m) => Question.fromDb(m)).toList();
  }

  Future<List<QuestionWithReponses>> getQuestionsByModule(int moduleId) async {
    final dbClient = await db();
    final questionMaps = await dbClient.query('questions', where: 'module_id = ?', whereArgs: [moduleId]);

    List<QuestionWithReponses> list = [];
    for (var qMap in questionMaps) {
      final reponseMaps = await dbClient.query('reponses', where: 'question_id = ?', whereArgs: [qMap['id']]);
      final reponses = reponseMaps.map((r) => Reponse.fromDb(r)).toList();

      list.add(QuestionWithReponses(
        question: Question.fromDb(qMap),
        reponses: reponses,
      ));
    }
    return list;
  }

  Future<void> removeAllDbQuestions() async {
    final db = await DbManager.db();
    await db.rawDelete('DELETE FROM questions');
  }

  Future<int?> countDbquestions() async {
    final db = await DbManager.db();
    final result = await db.rawQuery('SELECT COUNT(*) FROM questions');
    return Sqflite.firstIntValue(result);
  }

  // ---------------- Reponses CRUD ----------------

  Future<int> insertReponse(Reponse r) async {
    final dbClient = await db();
    return await dbClient.insert('reponses', r.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateReponse(Reponse r) async {
    final dbClient = await db();
    return await dbClient.update(
      'reponses',
      r.toMap(),
      where: 'id = ?',
      whereArgs: [r.id],
    );
  }

  Future<int> deleteReponse(int id) async {
    final dbClient = await db();
    return await dbClient.delete('reponses', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Reponse>> getReponsesByQuestion(int questionId) async {
    final dbClient = await db();
    final maps = await dbClient.query('reponses', where: 'question_id = ?', whereArgs: [questionId]);
    return maps.map((m) => Reponse.fromDb(m)).toList();
  }

  Future<void> removeAllDbReponse() async {
    final db = await DbManager.db();
    await db.rawDelete('DELETE FROM reponses');
  }

  Future<int?> countDbReponse() async {
    final db = await DbManager.db();
    final result = await db.rawQuery('SELECT COUNT(*) FROM reponses');
    return Sqflite.firstIntValue(result);
  }





//----------------------- Role ------------------------

  Future<int?> insertDbRole(Role role) async {
    final db = await DbManager.db();
    return await db.insert('roles', role.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Role>> getAllDbRoles() async {
    final db = await DbManager.db();
    final data = await db.query('roles');
    return data.map((json) => Role.fromJson(json)).toList();
  }

  Future<Role?> getDbRole(int onlineId) async {
    final db = await DbManager.db();
    final data = await db.query('roles', where: "online_id = ?", whereArgs: [onlineId], limit: 1);
    if (data.isNotEmpty) return Role.fromJson(data.first);
    return null;
  }

  Future<int?> updateDbRole(Role role) async {
    final db = await DbManager.db();
    return await db.update('roles', role.toJson(), where: "online_id = ?", whereArgs: [role.online_id]);
  }

  Future<void> removeDbRole(int onlineId) async {
    final db = await DbManager.db();
    await db.delete("roles", where: "online_id = ?", whereArgs: [onlineId]);
  }

  Future<void> removeAllDbRoles() async {
    final db = await DbManager.db();
    await db.rawDelete('DELETE FROM roles');
  }

  Future<int?> countDbRoles() async {
    final db = await DbManager.db();
    final result = await db.rawQuery('SELECT COUNT(*) FROM roles');
    return Sqflite.firstIntValue(result);
  }



  Future<int?> insertDbSousChapitre(SousChapitre sc) async {
    final db = await DbManager.db();
    return await db.insert('sous_chapitres', sc.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SousChapitre>> getAllDbSousChapitre() async {
    final db = await DbManager.db();
    final data = await db.query('sous_chapitres');
    return data.map((json) => SousChapitre.fromJson(json)).toList();
  }

  Future<SousChapitre?> getDbSousChapitre(int onlineId) async {
    final db = await DbManager.db();
    final data = await db.query('sous_chapitres', where: "online_id = ?", whereArgs: [onlineId], limit: 1);
    if (data.isNotEmpty) return SousChapitre.fromJson(data.first);
    return null;
  }

  Future<int?> updateDbSousChapitre(SousChapitre sc) async {
    final db = await DbManager.db();
    return await db.update('sous_chapitres', sc.toJson(), where: "online_id = ?", whereArgs: [sc.online_id]);
  }

  Future<void> removeDbSousChapitre(int onlineId) async {
    final db = await DbManager.db();
    await db.delete("sous_chapitres", where: "online_id = ?", whereArgs: [onlineId]);
  }

  Future<void> removeAllDbSousChapitre() async {
    final db = await DbManager.db();
    await db.rawDelete('DELETE FROM sous_chapitres');
  }

  Future<int?> countDbSousChapitre() async {
    final db = await DbManager.db();
    final result = await db.rawQuery('SELECT COUNT(*) FROM sous_chapitres');
    return Sqflite.firstIntValue(result);
  }



  // ================= DAO Commune =================
  Future<int?> insertDbCommune(Commune commune) async {
    final db = await DbManager.db();
    final data = {
      'id': commune.id,
      'online_id': commune.online_id,
      'pays_id': commune.pays_id,
      'pays_name': commune.pays_name,
      'commune_name': commune.commune_name,
      'code': commune.code,
    };
    return await db.insert(
      'communes',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Commune>> getAllDbCommunes() async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query('communes');
    return maps.map((e) => Commune.fromJson(e)).toList();
  }

  Future<List<Commune>> getDbCommunesByPaysId(int paysId) async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps =
    await db.query('communes', where: "pays_id = ?", whereArgs: [paysId]);
    return maps.map((e) => Commune.fromJson(e)).toList();
  }


  Future<int?> updateDbCommune(Commune commune) async {
    final db = await DbManager.db();
    final data = {
      'online_id': commune.online_id,
      'pays_id': commune.pays_id,
      'pays_name': commune.pays_name,
      'commune_name': commune.commune_name,
      'code': commune.code,
    };
    return await db.update(
      'communes',
      data,
      where: "id = ?",
      whereArgs: [commune.id],
    );
  }

  Future<int?> removeDbCommune(int id) async {
    final db = await DbManager.db();
    return await db.delete(
      'communes',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> removeAllDbCommunes() async {
    final db = await DbManager.db();
    await db.delete("communes");
  }

  Future<int?> countDbCommunes() async {
    final db = await DbManager.db();
    final result = await db.rawQuery("SELECT COUNT(*) FROM communes");
    return Sqflite.firstIntValue(result);
  }



  // ================= DAO Pays =================
  Future<int?> insertDbPays(Pays pays) async {
    final db = await DbManager.db();
    final data = {
      'id': pays.id,
      'online_id': pays.online_id,
      'pays_name': pays.pays_name,
      'code': pays.code,
    };
    return await db.insert(
      'pays',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Pays>> getAllDbPays() async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query('pays');
    return maps.map((e) => Pays.fromJson(e)).toList();
  }

  Future<Pays?> getDbPaysById(int id) async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps =
    await db.query('pays', where: "id = ?", whereArgs: [id], limit: 1);
    if (maps.isNotEmpty) {
      return Pays.fromJson(maps.first);
    }
    return null;
  }

  Future<int?> updateDbPays(Pays pays) async {
    final db = await DbManager.db();
    final data = {
      'online_id': pays.online_id,
      'pays_name': pays.pays_name,
      'code': pays.code,
    };
    return await db.update(
      'pays',
      data,
      where: "id = ?",
      whereArgs: [pays.id],
    );
  }

  Future<int?> removeDbPays(int id) async {
    final db = await DbManager.db();
    return await db.delete(
      'pays',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> removeAllDbPays() async {
    final db = await DbManager.db();
    await db.delete("pays");
  }

  Future<int?> countDbPays() async {
    final db = await DbManager.db();
    final result = await db.rawQuery("SELECT COUNT(*) FROM pays");
    return Sqflite.firstIntValue(result);
  }



  // 🔹 Insert Eleve
  Future<int> insertEleve(Eleve eleve) async {
    final db = await DbManager.db();
    return await db.insert("eleves", eleve.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 🔹 Get Eleve by ID
  Future<Eleve?> getEleveById(int id) async {
    final db = await DbManager.db();
    final maps =
    await db.query("eleves", where: "id = ?", whereArgs: [id], limit: 1);

    if (maps.isNotEmpty) {
      return Eleve.fromJson(maps.first);
    }
    return null;
  }

  // 🔹 Get All Eleves
  Future<List<Eleve>> getAllEleves() async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query("eleves");
    return maps.map((e) => Eleve.fromJson(e)).toList();
  }

  // 🔹 Update Eleve
  Future<int> updateEleve(Eleve eleve) async {
    final db = await DbManager.db();
    return await db.update(
      "eleves",
      eleve.toJson(),
      where: "id = ?",
      whereArgs: [eleve.id],
    );
  }

  // 🔹 Delete Eleve
  Future<int> deleteEleve(int id) async {
    final db = await DbManager.db();
    return await db.delete("eleves", where: "id = ?", whereArgs: [id]);
  }


  Future<void> deleteAllEleves() async {
    final db = await DbManager.db();
    await db.delete('eleves');
  }

  // 🔹 Count
  Future<int> countEleves() async {
    final db = await DbManager.db();
    return Sqflite.firstIntValue(
      await db.rawQuery("SELECT COUNT(*) FROM eleves"),
    ) ??
        0;
  }




  // Insérer un module sélectionné
  Future<int> insertSelectedModule(SelectedModule module) async {
    final db = await DbManager.db();
    return await db.insert('selected_modules', module.toJson());
  }

// Récupérer tous les modules sélectionnés
  Future<List<SelectedModule>> getAllSelectedModules() async {
    final db = await DbManager.db();
    final res = await db.query('selected_modules');
    return res.map((e) => SelectedModule.fromJson(e)).toList();
  }

// Supprimer tous les modules sélectionnés
  Future<void> removeAllSelectedModules() async {
    final db = await DbManager.db();
    await db.delete('selected_modules');
  }

  Future<void> updateModuleScore(int moduleId, int score,int totalTime) async {
    final db = await DbManager.db();

    await db.update(
      'selected_modules',
      {'score': score.toString(),
        'totalTime' : totalTime
      }, // stocke le score sous forme de string comme dans ton modèle
      where: 'module_id = ?',
      whereArgs: [moduleId],
    );
  }

  Future<void> updateselected_modules(int moduleId) async {
    final db = await DbManager.db();

    await db.update(
      'selected_modules',
      {'isDone': 1}, // stocke le score sous forme de string comme dans ton modèle
      where: 'module_id = ?',
      whereArgs: [moduleId],
    );
  }

  Future<bool> allModulesDone() async {
    final db = await DbManager.db();
    final result = await db.rawQuery('SELECT COUNT(*) as total, SUM(isDone) as done FROM selected_modules');

    if (result.isNotEmpty) {
      int total = result.first['total'] as int;
      int done = result.first['done'] as int? ?? 0;
      return total > 0 && total == done; // tous validés
    }
    return false;
  }



  // 🔹 CREATE
  Future<int> insertProgrammeData(ProgrammeData data) async {
    final db = await DbManager.db();
    return await db.insert('historiqueProgramme', data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 🔹 READ - Récupérer tout
  Future<List<ProgrammeData>> getAllProgrammeData() async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query('historiqueProgramme');
    return List.generate(maps.length, (i) => ProgrammeData.fromJson(maps[i]));
  }

  // 🔹 READ - Par ID
  Future<ProgrammeData?> getProgrammeDataById(int id) async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query(
      'historiqueProgramme',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ProgrammeData.fromJson(maps.first);
    }
    return null;
  }

  // 🔹 DELETE
  Future<int> deleteProgrammeData(int id) async {
    final db = await DbManager.db();
    return await db.delete(
      'historiqueProgramme',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 🔹 COUNT (optionnel)
  Future<int> countProgrammeData() async {
    final db = await DbManager.db();
    final result =
    await db.rawQuery('SELECT COUNT(*) as count FROM historiqueProgramme');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // 🔹 DELETE ALL (optionnel)
  Future<void> clearProgrammeData() async {
    final db = await DbManager.db();
    await db.delete('historiqueProgramme');
  }


    // 🔹 CREATE
  Future<int> insertModelData(ModuleData data) async {
    final db = await DbManager.db();
    return await db.insert('historiqueModules', data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 🔹 READ - Récupérer tout
  Future<List<ModuleData>> getAllModelData() async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query('historiqueModules');
    return List.generate(maps.length, (i) => ModuleData.fromJson(maps[i]));
  }

  // 🔹 READ - Par ID
  Future<ModuleData?> getModelDataById(int id) async {
    final db = await DbManager.db();
    final List<Map<String, dynamic>> maps = await db.query(
      'historiqueModules',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ModuleData.fromJson(maps.first);
    }
    return null;
  }

  // 🔹 DELETE
  Future<int> deleteModelData(int id) async {
    final db = await DbManager.db();
    return await db.delete(
      'historiqueModules',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 🔹 COUNT (optionnel)
  Future<int> countModelData() async {
    final db = await DbManager.db();
    final result =
    await db.rawQuery('SELECT COUNT(*) as count FROM historiqueModules');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // 🔹 DELETE ALL (optionnel)
  Future<void> clearModelData() async {
    final db = await DbManager.db();
    await db.delete('historiqueModules');
  }


}