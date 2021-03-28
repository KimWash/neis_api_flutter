# NEIS API

<a href="./README-en.md">English Document</a>

대한민국 교육청 산하 교육기관의 급식, 학사일정 API를 이용하기 위한 Flutter 용 패키지입니다.

!경고: 학교 설정 기능이 없어 함수의 파라미터에 교육청 코드와 학교 코드를 추가해주셔야 합니다. 학교 코드 및 교육청 코드 검색은 https://open.neis.go.kr/portal/data/dataset/searchDatasetPage.do 에서 학교기본정보 검색을 진행해주시면 됩니다.

`fetchMeals(MSCODE, SCCODE)`: `Future<List<Meal>>`을 반환합니다. `returnedValue[day - 1]` 에서 'day'는 일 수 입니다.

`fetchSchedules(MSCODE, SCCODE)`: `Future<List<Schedules>>`을 반환합니다. `returnedValue[day - 1]` 에서 'day'는 일 수 입니다.
## 예제
급식
```dart
//달의 1일의 급식 데이터 가져오기
fetchMeals('M10', '8000376').then((meals) {
    debugPrint(meals[0].breakfast);
    //출력: '달걀햄야채볶음밥\n종합어묵국\n소시지구이+케첩\n배추김치\n초코우유'
})
```

학사일정

```dart
//달의 1일의 학사일정 데이터 가져오기
fetchSchedules('M10', '8000376').then((schedules) {
    debugPrint(schedules[0].schedule);
    //출력: '신정'
})
```

더 많은 예제는 <a href="./example">example</a> 폴더를 참고해주세요.

## 시작하기

적용 (pubspec.yaml):
```dart
dependencies:
    ...
    neis_api:
```