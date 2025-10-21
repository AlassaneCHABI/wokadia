import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:wokadia/feature/utils/constant.dart';
import 'package:wokadia/feature/utils/preference_manager.dart';
import 'package:wokadia/models/users.dart';
import 'db_manager.dart';


class AuthService {
  final String baseUrl = API_BASE_URL;
  PreferenceManager pref_manager = PreferenceManager();
  DbManager db_manager = DbManager();
  DateTime currDate = new DateTime.now();

  Future<String> loginToServer(user) async {
    final authUrl = API_BASE_URL + '/login';

    final http.Response response = await http.post(Uri.parse(authUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user)
    );

    // print(response.body);
    var reponse_server = jsonDecode(response.body);
    var msg_server="";
    // print(reponse_server);

    if (response.statusCode == 200)
    {
      db_manager.removeAllDbUser();
      print("-------------------les details du users apres login----------------");
      print(reponse_server['user']);
      db_manager.insertDbUser(User.fromJson(reponse_server['user']));

      pref_manager.setFirstTime();
      pref_manager.setPrefItem('access_token',(reponse_server['access_token']).toString());
      pref_manager.setPrefItem('user_id',(reponse_server['user']['id']).toString());
      pref_manager.setPrefItem('organisation_id',(reponse_server['user']['organisation_id']).toString());
      //pref_manager.setPrefItem('pays_id',(reponse_server['user']['pays_id']).toString());
      //pref_manager.setPrefItem('pays_name',(reponse_server['user']['pays_name']).toString());
      pref_manager.setPrefItem('name',(reponse_server['user']['name']).toString());
      pref_manager.setPrefItem('email',(reponse_server['user']['email']).toString());
      pref_manager.setPrefItem('sexe',(reponse_server['user']['sexe']).toString());
      pref_manager.setPrefItem('contact',(reponse_server['user']['contact']).toString());
      pref_manager.setPrefItem('status',(reponse_server['user']['status']).toString());
      pref_manager.setPrefItem('slug',(reponse_server['user']['slug']).toString());
      pref_manager.setPrefItem('created_at',(reponse_server['user']['created_at']).toString());

      String user_id = (reponse_server['user']['id']).toString();

      msg_server = "succes***"+user_id;
    }
    else {
      msg_server = reponse_server['message'];
    }
    return msg_server;
  }


  Future registerUserProfile(user) async {
    final authUrl = API_BASE_URL + '/register';

    final http.Response response = await http.post(Uri.parse(authUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user)
    );

    var reponse_server = jsonDecode(response.body);

    print(reponse_server['user']);
    var msg_server="";
    // print(reponse_server);

    if (response.statusCode == 200)
    {
      db_manager.removeAllDbUser();
      //db_manager.insertDbUser(User.fromJson(reponse_server['user']));

      /*List<dynamic> liste_domaines = reponse_server['domaines'];
      liste_domaines.forEach((item) {
        Domaine ce_item = Domaine(
          item['id'],
          item['name'],
          item['detail']??"vide",
        );
        db_manager.insertDbDomaine(ce_item);
      });*/

     /* pref_manager.setPrefItem('access_token',(reponse_server['access_token']).toString());
      pref_manager.setPrefItem('user_id',(reponse_server['user']['id']).toString());
      pref_manager.setPrefItem('pays_id',(reponse_server['user']['pays_id']).toString());
      pref_manager.setPrefItem('pays_name',(reponse_server['user']['pays_name']).toString());
      pref_manager.setPrefItem('full_name',(reponse_server['user']['full_name']).toString());
      pref_manager.setPrefItem('email',(reponse_server['user']['email']).toString());
      pref_manager.setPrefItem('phone1',(reponse_server['user']['phone1']).toString());*/

      msg_server = "succes";
    }
    else {
      msg_server = reponse_server['message'];
    }
    return msg_server;
  }



}
