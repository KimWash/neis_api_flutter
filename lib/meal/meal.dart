import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:neis_api/tools/datautils.dart';

final formatter = DateFormat('yyyyMMdd');

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
    return null;
  }
}

List<Meal> parseMeals(dynamic res) {
  final parsed = res.cast<Map<String, dynamic>>();
  List<List<String>> days = [];
  DateTime date = DateTime.tryParse(parsed[0]['MLSV_YMD']);
  final lastday = lengthCheck(DateTime(date.year, date.month + 1, 0)
      .day
      .toString()); // get last day of month
  for (var i = 0; i < int.parse(lastday) + 1; i++) {
    List<String> mealsToAdd = ['', '', ''];
    for (var meal in parsed) {
      if (meal['MLSV_YMD'] ==
          "${date.year}${lengthCheck(date.month.toString())}${lengthCheck((i + 1).toString())}") {
        mealsToAdd[(int.parse(meal['MMEAL_SC_CODE']) - 1)] = (meal['DDISH_NM']);
      }
    }
    days.add(mealsToAdd);
  }
  return days.map((e) => Meal.fromList(e)).toList();
}

Future<List<Meal>> fetchMeals(
    String mscode, String sccode, int year, int month) async {
  final newMonth =
      lengthCheck(month.toString()); //append 0 front if one digit number
  final lastday = lengthCheck(DateTime(year, month + 1, 0).day.toString());

  final start = "$year${newMonth}01";
  final end = "$year$newMonth$lastday";

  final res = await http.get(Uri.parse(
      "https://open.neis.go.kr/hub/mealServiceDietInfo?ATPT_OFCDC_SC_CODE=$mscode&SD_SCHUL_CODE=$sccode&Type=meal&KEY=76ebe67f34c44b7ba5c10ac9f3b4060e&MLSV_FROM_YMD=$start&MLSV_TO_YMD=$end&Type=json"));
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
  return null;
}
