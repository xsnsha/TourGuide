import 'package:flutter/material.dart';
import 'package:tourguide/dao/DatabaseProvider.dart';
import 'package:tourguide/entities/UserInfo.dart';
import 'package:tourguide/ui/AgentPage.dart';
import 'package:tourguide/ui/UserPage.dart';

enum RoleEnum { user, agent }

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  bool showProgress = false;
  UserInfo _userInfo = UserInfo();
  DatabaseProvider provider = DatabaseProvider();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Путеводитель"),
        backgroundColor: Color(0xFF143248),
      ),
      body: Container(
        color: const Color(0xFF102637),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Авторизация",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20.0),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    _userInfo.setName(value);
                  }
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Введите ФИО",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    _userInfo.setLogin(value);
                  }
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Введите логин",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    _userInfo.setPass(value);
                  }
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Введите пароль",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)))),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Theme(
                  data: Theme.of(context)
                      .copyWith(unselectedWidgetColor: Colors.white54),
                  child: Radio<RoleEnum>(
                    value: RoleEnum.user,
                    groupValue: _userInfo.roleEnum,
                    onChanged: (RoleEnum? value) {
                      if(value != null){
                        setState(() {
                          _userInfo.setRole(value);
                        });
                      }
                    },
                  ),
                ),
                const Text('Пользователь',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    )),
                const SizedBox(
                  width: 20.0,
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(unselectedWidgetColor: Colors.white54),
                  child: Radio<RoleEnum>(
                    value: RoleEnum.agent,
                    groupValue: _userInfo.roleEnum,
                    onChanged: (RoleEnum? value) {
                      if(value != null){
                        setState(() {
                          _userInfo.setRole(value);
                        });
                      }
                    },
                  ),
                ),
                const Text('Представитель',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    )),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Material(
              elevation: 5,
              color: Color(0xff318ADD),
              borderRadius: BorderRadius.circular(32.0),
              child: MaterialButton(
                onPressed: () async {
                  if(_userInfo.isValidForm){
                    final res = await provider.createUserTable(_userInfo);
                    if(res != -1 && res != 0){
                      _userInfo.setId(res);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>
                        _userInfo.roleEnum == RoleEnum.agent
                            ? AgentPage(_userInfo) : UserPage(_userInfo)
                        ),
                      );
                    }
                  }
                },
                minWidth: 200.0,
                height: 55.0,
                child: Text(
                  "Вход",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
