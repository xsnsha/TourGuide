import 'package:flutter/material.dart';
import 'package:tourguide/dao/DatabaseProvider.dart';
import 'package:tourguide/entities/City.dart';
import 'package:tourguide/entities/Object.dart';
import 'package:tourguide/entities/UserInfo.dart';
import 'package:tourguide/ui/NotFound.dart';
import 'package:tourguide/ui/ObjectItem.dart';
import 'package:tourguide/ui/UserBlockInfo.dart';

import 'CitiesDialog.dart';

class AgentPage extends StatefulWidget {
  final UserInfo _userInfo;

  AgentPage(this._userInfo);

  @override
  _AgentPageState createState() => _AgentPageState(_userInfo);
}

class _AgentPageState extends State<AgentPage> {
  final UserInfo _userInfo;
  DatabaseProvider provider = DatabaseProvider();
  ObjectInfo objectInfo = ObjectInfo();
  List<City> cities = [];
  City? selectedCity;

  _AgentPageState(this._userInfo);

  @override
  void initState() {
    super.initState(); //Логин: scscscs, Пароль: cscsc
    provider.getAgentObjects(_userInfo.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Представитель"),
        backgroundColor: Color(0xFF143248),
      ),
      body: Container(
        color: const Color(0xFF102637),
        height: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                UserBlockInfo(_userInfo),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 25),
                              child: Text(
                                "Создание объекта",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20.0),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: TextField(
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  if (value.trim().isNotEmpty) {
                                    objectInfo.name = value;
                                  }
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: "Введите название",
                                    hintStyle: TextStyle(color: Colors.white70),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)))),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 3,
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 20),
                                    child: TextField(
                                      controller: TextEditingController()
                                        ..text = objectInfo.address,
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                        if (value.trim().isNotEmpty) {
                                          objectInfo.address = value;
                                        }
                                      },
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                          hintText: "Введите адрес",
                                          hintStyle:
                                              TextStyle(color: Colors.white70),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32.0)))),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.location_city,
                                      size: 30.0,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () async {
                                      cities = await provider.getListsOfCity();
                                      if (cities.isNotEmpty) {
                                        final res = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Список городов',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                backgroundColor: Color(
                                                  0xFF143248,
                                                ),
                                                content:
                                                    showCitiesContainer(cities),
                                              );
                                            });
                                        if (res is City) {
                                          setState(() {
                                            selectedCity = res;
                                            objectInfo.idCity =
                                                selectedCity?.id ?? -1;
                                            objectInfo.address =
                                                "${selectedCity?.name}, ";
                                          });
                                        }
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              margin: const EdgeInsets.only(bottom: 20),
                              child: TextField(
                                textAlign: TextAlign.center,
                                onChanged: (value) {
                                  if (value.trim().isNotEmpty) {
                                    objectInfo.workTime = value;
                                  }
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: "Введите время проведения",
                                    hintStyle: TextStyle(color: Colors.white70),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0)))),
                              ),
                            ),
                            Material(
                              elevation: 5,
                              color: Color(0xff318ADD),
                              borderRadius: BorderRadius.circular(32.0),
                              child: MaterialButton(
                                onPressed: () async {
                                  print('isValidForm ${objectInfo.isValidForm}');
                                  if (objectInfo.isValidForm) {
                                    provider.createObjectTable(
                                        objectInfo, _userInfo);
                                  }
                                },
                                minWidth: 200.0,
                                height: 55.0,
                                child: Text(
                                  "Создать объект",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20.0),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 25),
                              child: Text(
                                "Мои объекты",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20.0),
                              ),
                            ),
                            StreamBuilder<List<ObjectInfo>>(
                              stream: provider.objectsAgentStream.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data != null &&
                                      snapshot.data!.isNotEmpty) {
                                    return Column(
                                      children: snapshot.data!
                                          .map((e) => ObjectItem(e, null))
                                          .toList(),
                                    );
                                  } else {
                                    return NotFound();
                                  }
                                } else {
                                  return NotFound();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    provider.closeAgentStream();
    super.dispose();
  }
}
