import 'package:neis_api/meal/meal.dart';
import 'package:neis_api/schedule/schedule.dart';

const mscode = [
  'B10',
  'C10',
  'D10',
  'E10',
  'F10',
  'G10',
  'H10',
  'I10',
  'J10',
  'K10',
  'M10',
  'N10',
  'P10',
  'Q10',
  'R10',
  'S10',
  'T10',
  'V10'
];

enum Region {
  SEOUL,
  BUSAN,
  DAEGU,
  INCHEON,
  GWANGJU,
  DAEJEON,
  ULSAN,
  SEJONG,
  GYEONGGI,
  GANGWON,
  CHUNGBUK,
  CHUNGNAM,
  JEONBUK,
  JEONNAM,
  GYEONGBUK,
  GYEONGNAM,
  JEJU,
  FORIENGER
}

class School {
  final Region region;
  final String code;
  var mealCache = Map<int, List<Meal>>();
  var scheduleCache = Map<int, List<Schedule>>();

  School(this.region, this.code);

  Future<List<Meal>> getMonthlyMeal(int year, int month) async {
    final cacheKey = year * 12 + month;

    if (mealCache != null) {
      if (mealCache.containsKey(cacheKey)) {
        return mealCache[cacheKey];
      }
    }
    final meal = await fetchMeals(mscode[region.index], code, year, month);
    mealCache[cacheKey] = meal;
    return meal;
  }

  Future<List<Schedule>> getMonthlySchedule(int year, int month) async {
    final cacheKey = year * 12 + month;
    if (scheduleCache.containsValue(cacheKey)) {
      return scheduleCache[cacheKey];
    }

    final schedule =
        await fetchSchedules(mscode[region.index], code, year, month);
    scheduleCache[cacheKey] = schedule;

    return schedule;
  }

  clearCache() {
    mealCache.clear();
    scheduleCache.clear();
  }
}
