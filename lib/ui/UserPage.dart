import 'package:flutter/material.dart';
import 'package:tourguide/dao/DatabaseProvider.dart';
import 'package:tourguide/entities/Object.dart';
import 'package:tourguide/entities/ObjectAgent.dart';
import 'package:tourguide/entities/UserInfo.dart';
import 'package:tourguide/ui/NotFound.dart';
import 'package:tourguide/ui/ObjectItem.dart';
import 'package:tourguide/ui/UserBlockInfo.dart';

class UserPage extends StatefulWidget{
  final UserInfo _userInfo;

  UserPage(this._userInfo);

  @override
  _UserPageState createState() => _UserPageState(_userInfo);
}

class _UserPageState extends State<UserPage>{
  final UserInfo _userInfo;
  DatabaseProvider provider = DatabaseProvider();

  _UserPageState(this._userInfo);

  @override
  void initState() {
    super.initState();
    provider.getAllObjects();
    provider.getUserObjects(_userInfo.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Пользователь"),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(right: 15, left: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 25),
                              child: Text(
                                "Все объекты",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20.0),
                              ),
                            ),
                            StreamBuilder<List<ObjectInfo>>(
                              stream: provider.objectsAllStream.stream,
                              builder: (context, snapshot){
                                if(snapshot.hasData){
                                  if(snapshot.data != null && snapshot.data!.isNotEmpty){
                                    return Column(
                                      children:
                                      snapshot.data!.map((e) => InkWell(
                                          onTap: () async {
                                            provider.createObjectUser(
                                                ObjectUser()..idUser
                                                = _userInfo.id..id = e.id);
                                          },
                                          child: ObjectItem(e, null))).toList(),
                                    );
                                  }else{
                                    return NotFound();
                                  }
                                }else{
                                  return NotFound();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(right: 15, left: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 25),
                              child: Text(
                                "Выбранные объекты",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20.0),
                              ),
                            ),
                            StreamBuilder<List<ObjectInfo>>(
                              stream: provider.objectsUserStream.stream,
                              builder: (context, snapshot){
                                if(snapshot.hasData){
                                  if(snapshot.data != null && snapshot.data!.isNotEmpty){
                                    return Column(
                                      children: snapshot.data!.map((e) =>
                                          InkWell(
                                            onTap: () async {
                                              provider.deleteUserObject(
                                                  ObjectUser()..idUser = _userInfo.id
                                                  ..id = e.id
                                              );
                                            },
                                            child: ObjectItem(e, Color(0xFF7875D4)
                                                .withOpacity(0.3)),
                                          )).toList(),
                                    );
                                  }else{
                                    return NotFound();
                                  }
                                }else{
                                  return NotFound();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    provider.closeAllStream();
    provider.closeUserStream();
    super.dispose();
  }
}