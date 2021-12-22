class ObjectInfo {
  String name = "";
  String workTime = "";
  String address = "";
  int _id = -1;
  int idCity = -1;

  ObjectInfo();

  int get id => _id;

  bool get isValidForm => name.isNotEmpty && workTime.isNotEmpty && address.isNotEmpty && idCity != -1;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnObjectName: name,
      columnObjectWorkTime: workTime,
      columnObjectAddress: address
    };
    if (_id != -1) {
      map[columnObjectsId] = _id;
    }
    if (idCity != -1) {
      map[columnObjectCityId] = idCity;
    }
    return map;
  }

  ObjectInfo.fromMap(Map<String, Object?> map) {
    name = map[columnObjectName] as String;
    workTime = map[columnObjectWorkTime] as String;
    address = map[columnObjectAddress] as String;
    _id = map[columnObjectsId] as int;
    idCity = map[columnObjectCityId] as int;
  }
}

final String tableObjectName = 'Объект';
final String columnObjectName = "Название";
final String columnObjectAddress = 'Адрес';
final String columnObjectWorkTime = 'Режим_работы';
final String columnObjectsId = 'idОбъекта';
final String columnObjectCityId = 'idГорода';
