import 'package:tourguide/ui/LoginPage.dart';

class UserInfo {
  RoleEnum _roleEnum = RoleEnum.user;
  String _name = "";
  String _login = "";
  String _pass = "";
  int _id = -1;

  UserInfo();

  void setRole(RoleEnum roleEnum) => this._roleEnum = roleEnum;

  RoleEnum get roleEnum => _roleEnum;

  void setName(String name) => this._name = name;

  String get name => _name;

  void setLogin(String login) => this._login = login;

  String get login => _login;

  void setPass(String pass) => this._pass = pass;

  String get pass => _pass;

  int get id => _id;

  void setId(int id) => this._id = id;

  bool get isValidForm => _pass.isNotEmpty && _login.isNotEmpty && _name.isNotEmpty;

  @override
  String toString() {
    return "role = $roleEnum\nname = $name\nlogin = $login\npass = $pass";
  }

  String get tableName => _roleEnum == RoleEnum.user ? tableUser : tableAgent;

  String get columnId => _roleEnum == RoleEnum.user ? columnUserId : columnAgentId;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnName: _name,
      columnLogin: _login,
      columnPass: _pass
    };
    if (_id != -1) {
      if(roleEnum == RoleEnum.user){
        map[columnUserId] = _id;
      }else{
        map[columnAgentId] = _id;
      }
    }
    return map;
  }

  UserInfo.fromMap(RoleEnum roleEnum, Map<String, Object?> map) {
    _name = map[columnName] as String;
    _login = map[columnLogin] as String;
    _pass = map[columnPass] as String;
    _roleEnum = roleEnum;
    _id = (roleEnum == RoleEnum.user
        ? map[columnUserId] : map[columnAgentId]) as int;
  }
}

final String tableUser = 'Пользователь';
final String tableAgent = 'Представитель';
final String columnUserId = 'idПользователя';
final String columnAgentId = 'idПредставителя';
final String columnName = 'ФИО';
final String columnLogin = 'Логин';
final String columnPass = 'Пароль';
