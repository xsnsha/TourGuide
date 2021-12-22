import 'package:tourguide/entities/Object.dart';
import 'package:tourguide/entities/UserInfo.dart';

final String tableObjectAgent = 'Объект_представителя';
final String tableObjectUser= 'Объект_пользователя';
final String columnObjectId = 'Идентификатор_обьекта';

class ObjectAgent {
  int id = -1;
  int idAgent = -1;

  ObjectAgent();

  Map<String, Object?> toMap() {
    var map = <String, Object?>{};
    if (id != -1) {
      map[columnObjectId] = id;
    }
    if (idAgent != -1) {
      map[columnAgentId] = idAgent;
    }
    return map;
  }

  ObjectAgent.fromMap(Map<String, Object?> map) {
    id = map[columnObjectId] as int;
    idAgent = map[columnAgentId] as int;
  }
}

class ObjectUser {
  int id = -1;
  int idUser = -1;

  ObjectUser();

  Map<String, Object?> toMap() {
    var map = <String, Object?>{};
    if (id != -1) {
      map[columnObjectId] = id;
    }
    if (idUser != -1) {
      map[columnUserId] = idUser;
    }
    return map;
  }

  ObjectUser.fromMap(Map<String, Object?> map) {
    id = map[columnObjectId] as int;
    idUser = map[columnUserId] as int;
  }
}