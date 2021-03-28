# NEIS API

A package for use data from South Korea schools.

!Warning: School change not supported yet. you must pass school paramerters every time call functions.

`fetchMeals(MSCODE, SCCODE)`: returns `Future<List<Meal>>`. `returnedValue[day - 1]` 'day' is day of month.

## Example
Meals
```dart
//getting Meal on first day of month
fetchMeals('M10', '8000376').then((meals) {
    debugPrint(meals[0].breakfast);
    //output: '달걀햄야채볶음밥\n종합어묵국\n소시지구이+케첩\n배추김치\n초코우유'
})
```

Schedules

```dart
//getting Schedule on first day of month
fetchSchedules('M10', '8000376').then((schedules) {
    debugPrint(schedules[0].schedule);
    //output: '달걀햄야채볶음밥\n종합어묵국\n소시지구이+케첩\n배추김치\n초코우유'
})
```

## Getting Started

Implementation:
```dart
dependencies:
    ...
    neis_api:
```