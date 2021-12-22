

import 'package:flutter/material.dart';
import 'package:tourguide/entities/Object.dart';

class ObjectItem extends StatelessWidget{
  final ObjectInfo objectInfo;
  Color? color;

  ObjectItem(this.objectInfo, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Color(0xFF143248).withOpacity(0.9),
      margin: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Информация об объекте:",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18.0
              ),
            ),
            Text(
              "Название: ${objectInfo.name}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Адрес: ${objectInfo.address}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
                const SizedBox(width: 10,),
                Text(
                  "Дата проведения: ${objectInfo.workTime}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              ],
            )
          ],
        )
      ),
    );
  }

}