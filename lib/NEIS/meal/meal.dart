import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:neis_api/NEIS/tools/datautils.dart';

final now = DateTime.now();
final formatter = DateFormat('yyyyMMdd');
final lastday =
    lengthCheck(DateTime(now.year, now.month + 1, 0).day.toString());

class Meal {
  final String breakfast;
  final String lunch;
  final String dinner;

  Meal({this.breakfast, this.lunch, this.dinner});

  factory Meal.fromList(List<String> meal) {
    final noMealString = '급식이 없는 것 같아요 :(';
    if (meal != null && meal.isNotEmpty == true) {
      return Meal(
        breakfast: meal[0] == ''
            ? noMealString
            : meal[0]
                .replaceAll(new RegExp(r"[0-9.*]"), "")
                .replaceAll('<br/>', "\n"),
        lunch: meal[1] == ''
            ? noMealString
            : meal[1]
                .replaceAll(new RegExp(r"[0-9.*]"), "")
                .replaceAll('<br/>', "\n"),
        dinner: meal[2] == ''
            ? noMealString
            : meal[2]
                .replaceAll(new RegExp(r"[0-9.*]"), "")
                .replaceAll('<br/>', "\n"),
      );
    }
  }
}

List<Meal> parseMeals(dynamic res) {
  final parsed = res.cast<Map<String, dynamic>>();
  List<List<String>> days = [];
  for (var i = 0; i < int.parse(lastday) + 1; i++) {
    List<String> mealsToAdd = ['', '', ''];
    for (var meal in parsed) {
      if (meal['MLSV_YMD'] ==
          "${now.year}${lengthCheck(now.month.toString())}${lengthCheck((i + 1).toString())}") {
        mealsToAdd[(int.parse(meal['MMEAL_SC_CODE']) - 1)] = (meal['DDISH_NM']);
      }
    }
    //debugPrint(meals.toString());
    days.add(mealsToAdd);
  }
  return days.map((e) => Meal.fromList(e)).toList();
}

Future<List<Meal>> fetchMeals() async {
  var month = lengthCheck(now.month.toString());
  final lastday =
      lengthCheck(DateTime(now.year, now.month + 1, 0).day.toString());

  final start = "${now.year}${month}01";
  final end = "${now.year}${month}${lastday}";

  debugPrint(
      "https://open.neis.go.kr/hub/mealServiceDietInfo?ATPT_OFCDC_SC_CODE=M10&SD_SCHUL_CODE=8000376&Type=meal&KEY=76ebe67f34c44b7ba5c10ac9f3b4060e&MLSV_FROM_YMD=$start&MLSV_TO_YMD=$end&Type=json");
  final res = await http.get(Uri.parse(
      "https://open.neis.go.kr/hub/mealServiceDietInfo?ATPT_OFCDC_SC_CODE=M10&SD_SCHUL_CODE=8000376&Type=meal&KEY=76ebe67f34c44b7ba5c10ac9f3b4060e&MLSV_FROM_YMD=$start&MLSV_TO_YMD=$end&Type=json"));
  if (res.statusCode == 200) {
    var jsonBody = json.decode(res.body);

    if (jsonBody['mealServiceDietInfo'][0]['head'][1]["RESULT"]["CODE"] ==
        'INFO-000') {
      return compute(parseMeals, jsonBody['mealServiceDietInfo'][1]['row']);
    } else if (jsonBody["RESULT"]["CODE"] == 'INFO-200') {
      return null;
    }
  } else {
    throw Exception('Failed..;');
  }
}
