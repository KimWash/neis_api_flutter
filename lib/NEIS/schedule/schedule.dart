import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neis_api/NEIS/tools/datautils.dart';

final now = DateTime.now();
final formatter = DateFormat('yyyyMMdd');
final lastday =
    lengthCheck(DateTime(now.year, now.month + 1, 0).day.toString());

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
  for (var i = 0; i < int.parse(lastday) + 1; i++) {
    String schedulesToAdd = '';
    var j = 0;
    for (var schedule in parsed) {
      j += 1;
      if (schedule['AA_YMD'] ==
          "${now.year}${lengthCheck(now.month.toString())}${lengthCheck((i + 1).toString())}") {
        schedulesToAdd += j == parsed.length
            ? (schedule['SBTR_DD_SC_NM'] + "\n")
            : (schedule['SBTR_DD_SC_NM']);
      }
    }
    days.add(schedulesToAdd);
  }
  return days.map((e) => Schedule.fromList(e)).toList();
}

Future<List<Schedule>> fetchSchedules(String MSCODE, String SCCODE) async {
  var month = lengthCheck(now.month.toString());
  final lastday =
      lengthCheck(DateTime(now.year, now.month + 1, 0).day.toString());

  final start = "${now.year}${month}01";
  final end = "${now.year}${month}${lastday}";

  String firstDayOfMonth = formatter.format(DateTime(now.year, now.month, 1));
  String endOfMonth = formatter.format(DateTime(now.year, now.month + 1, 0));
  final res = await http.get(Uri.parse(
      'https://open.neis.go.kr/hub/SchoolSchedule?ATPT_OFCDC_SC_CODE=$MSCODE&SD_SCHUL_CODE=$SCCODE&Type=json&AA_FROM_YMD=$start&AA_TO_YMD=$end'));
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
}
