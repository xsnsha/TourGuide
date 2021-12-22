
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tourguide/entities/UserInfo.dart';

class UserBlockInfo extends StatelessWidget{
  final UserInfo _userInfo;

  UserBlockInfo(this._userInfo);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF6750F3).withOpacity(0.3),
      shadowColor: Color(0xFFFFFFFF).withOpacity(0.5),
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Роль: ${_userInfo.tableName}",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18.0),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Логин: ${_userInfo.login}",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18.0),
              ),
            ),
            Text(
              "ФИО: ${_userInfo.name}",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0),
            ),

          ],
        ),
      ),
    );
  }
}