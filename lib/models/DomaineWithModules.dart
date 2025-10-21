import 'package:wokadia/models/domaines.dart';
import 'package:wokadia/models/modules.dart';

class DomaineWithModules {
  Domaines domaine;
  List<Modules> modules;

  DomaineWithModules({
    required this.domaine,
    required this.modules,
  });
}
