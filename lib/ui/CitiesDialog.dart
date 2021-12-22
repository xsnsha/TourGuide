import 'package:flutter/material.dart';
import 'package:tourguide/entities/City.dart';

Widget showCitiesContainer(List<City> cities) {
  return Container(
    height: 300.0,
    width: 300.0,
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: cities.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context, cities[index]);
          },
          child: ListTile(
            title: Text(
              cities[index].name,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    ),
  );
}
