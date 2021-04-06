# NEIS API

대한민국 교육청 산하 교육기관의 급식, 학사일정 API를 이용하기 위한 Flutter용 패키지입니다.

## 사용법

### 시작하기

pubspec.yaml에 패키지를 추가합니다.
```dart
dependencies:
    ...
    neis_api:
```

### 학교 클래스 객체 생성
```dart
final school = School(region:Region, code:String);
```
`region` 은 시도교육청 코드, `code` 는 학교코드입니다. 학교코드는 <a href="https://open.neis.go.kr/portal/data/service/selectServicePage.do?page=1&rows=10&sortColumn=&sortDirection=&infId=OPEN17020190531110010104913&infSeq=1">여기</a>에서 검색 가능합니다. `School` 객체를 생성합니다.

### 월간 급식 불러오기
```dart
final meals = await school.getMonthlyMeal(year:int, month:int);
```
`Future<List<Meal>>` 를 반환합니다. meals의 인덱스는 (불러오려는 일수) - 1 입니다. `ex) 5일 => meals[5 - 1]`

### 월간 학사일정 불러오기
```dart
final day = DateTime.now().day;
final schedules = await school.getMonthlySchedule(year:int, month:int);
debugPrint(schedules[day - 1].schedules);
```
`Future<List<Schedule>>` 를 반환합니다. schedules의 인덱스는 (불러오려는 일수) - 1 입니다. `ex) 5일 => schedules[5 - 1]`


### 시도교육청 코드
Region.CHUNGBUK과 같은 형태로 입력합니다.

| 값 | 교육청명 | 반환값 |
|----|----|----|
| `Region.SEOUL` | 서울특별시교육청 | `B10` |
| `Region.BUSAN` | 부산광역시교육청 | `C10` |
| `Region.DAEGU` | 대구광역시교육청 | `D10` |
| `Region.INCHEON` | 인천광역시교육청 | `E10` |
| `Region.GWANGJU` | 광주광역시교육청 | `F10` |
| `Region.DAEJEON` | 대전광역시교육청 | `G10` |
| `Region.ULSAN` | 울산광역시교육청 | `H10` |
| `Region.SEJONG` | 세종특별자치시교육청 | `I10` |
| `Region.GYEONGGI` | 경기도교육청 | `J10` |
| `Region.GANGWON` | 강원도교육청 | `K10` |
| `Region.CHUNGBUK` | 충청북도교육청 | `M10` |
| `Region.CHUNGNAM` | 충청남도교육청 | `N10` |
| `Region.JEONBUK` | 전라북도교육청 | `P10` |
| `Region.JEONNAM` | 전라남도교육청 | `Q10` |
| `Region.GYEONGBUK` | 경상북도교육청 | `R10` |
| `Region.GYEONGNAM` | 경상남도교육청 | `S10` |
| `Region.JEJU` | 제주특별자치도교육청 | `T10` |
| `Region.FORIENGER` | 재외한국학교교육청 | `V10` |

## 예제
급식
```dart
// 4월 1일 조식 가져오기
final school = School(Region.CHUNGBUK, '8000376');
final meals = await school.getMonthlyMeal(2021, 4);
debugPrint(meals[0].breakfast);
// 예시 출력: '달걀햄야채볶음밥\n종합어묵국\n소시지구이+케첩\n배추김치\n초코우유'
```

학사일정

```dart
// 1월 1일 학사일정 가져오기
final school = School(Region.CHUNGBUK, '8000376');
final schedules = await school.getMonthlySchedule(2021, 1);
debugPrint(schedules[0].schedule);
// 예시 출력: '신정'
```

UI 적용 예제는 <a href="./example">example</a> 폴더를 참고해주세요.

