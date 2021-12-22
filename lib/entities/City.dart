class City {
  String name = "";
  int _id = -1;

  City(String name){
    this.name = name;
  }

  int get id => _id;

  bool get isValidForm => name.isNotEmpty;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnCityName: name
    };
    if (_id != -1) {
      map[columnCityId] = _id;
    }
    return map;
  }

  City.fromMap(Map<String, Object?> map) {
    name = map[columnCityName] as String;
    _id = map[columnCityId] as int;
  }
}

final List<City> mockCities = [
  City("Санкт-Петербург"),
  City("Москва"),
  City("Казань")
];

final String tableCityName = 'Город';
final String columnCityName = "Название";
final String columnCityId = 'idГорода';
