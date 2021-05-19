import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:neis_api/tools/datautils.dart';

final formatter = DateFormat('yyyyMMdd');

class Schedule {
  final String schedule;

  Schedule({this.schedule});

  factory Schedule.fromList(String schedules) {
    final noScheduleString = "학사일정이 없는 것 같아요 :)";
    return Schedule(schedule: schedules == '' ? noScheduleString : schedules);
  }
}

List<Schedule> parseSchedules(dynamic res) {
  final parsed = res.cast<Map<String, dynamic>>();
  List<String> days = [];
  DateTime date = DateTime.tryParse(parsed[0]['AA_YMD']);
  final lastday = lengthCheck(DateTime(date.year, date.month + 1, 0)
      .day
      .toString()); // get last day of month
  for (var i = 0; i < int.parse(lastday) + 1; i++) {
    String schedulesToAdd = '';
    var j = 0;
    for (var schedule in parsed) {
      j += 1;
      if (schedule['AA_YMD'] ==
          "${date.year}${lengthCheck(date.month.toString())}${lengthCheck((i + 1).toString())}") {
        schedulesToAdd += j == parsed.length
            ? (schedule['SBTR_DD_SC_NM'] + "\n")
            : (schedule['SBTR_DD_SC_NM']);
      }
    }
    days.add(schedulesToAdd);
  }
  return days.map((e) => Schedule.fromList(e)).toList();
}

Future<List<Schedule>> fetchSchedules(
    String mscode, String sccode, int year, int month) async {
  final newMonth = lengthCheck(month.toString());
  final lastday = lengthCheck(DateTime(year, month + 1, 0).day.toString());

  final start = "$year${newMonth}01";
  final end = "$year$newMonth$lastday";

  final res = await http.get(Uri.parse(
      'https://open.neis.go.kr/hub/SchoolSchedule?ATPT_OFCDC_SC_CODE=$mscode&SD_SCHUL_CODE=$sccode&Type=json&AA_FROM_YMD=$start&AA_TO_YMD=$end'));
  if (res.statusCode == 200) {
    var jsonBody = json.decode(res.body);

    if (jsonBody['SchoolSchedule'][0]['head'][1]["RESULT"]["CODE"] ==
        'INFO-000') {
      return compute(parseSchedules, jsonBody['SchoolSchedule'][1]['row']);
    } else if (jsonBody["RESULT"]["CODE"] == 'INFO-200') {
      return null;
    }
  } else {
    throw Exception('Failed..;');
  }
  return null;
}
