import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neis_api/school/school.dart';

void main(List<String> args) {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MealPage(),
    );
  }
}

class MealPage extends StatefulWidget {
  @override
  MealPageState createState() => MealPageState();
}

class MealPageState extends State<MealPage> {
  var school = School(Region.CHUNGBUK, '8000376');
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: school.getMonthlyMeal(2021, 4),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data[now.day - 1].lunch);
            } else if (!snapshot.hasData) {
              return Text("급식을 불러오지 못 했습니다.");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
