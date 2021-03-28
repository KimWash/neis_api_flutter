import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neis_api/NEIS/meal/meal.dart';

class MealPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MealPageWidget();
}

class MealPageWidget extends State<MealPage> {
  Future<List<Meal>> meals;
  final now = DateTime.now();

  @override
  void initState() {
    meals = fetchMeals('M10', '8000376');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Scaffold(
      body: Container(
        child: FutureBuilder(
          future: meals,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data[now.day - 1].breakfast);
            }
          },
        ),
      ),
    );
  }
}
