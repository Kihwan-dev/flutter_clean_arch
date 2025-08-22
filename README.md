# 🏗️ Flutter 클린 아키텍처 - 각 파일 역할 설명

## 📋 목차
- [클린 아키텍처란?](#클린-아키텍처란)
- [3층 구조](#3층-구조)
- [각 파일별 역할](#각-파일별-역할)
- [데이터 흐름](#데이터-흐름)
- [전체 흐름 요약](#전체-흐름-요약)

## 🏠 클린 아키텍처란?

클린 아키텍처는 **잘 설계된 집**과 같다. 각 부분이 명확한 역할을 가지고 서로 협력하면서 깔끔하게 동작하는 구조

### 🎯 핵심 원칙
- **의존성 방향**: 안쪽(Domain)은 바깥쪽(Data, Presentation)에 의존하지 않음
- **테스트 용이성**: 각 부분을 독립적으로 테스트 가능
- **유지보수성**: 데이터 소스나 UI가 바뀌어도 비즈니스 로직은 그대로

## 📐 3층 구조

### **1층 (Data Layer) - 기초공사**
```
lib/data/
├── data_source/     ← 외부 데이터 가져오기 (API, 파일 등)
├── dto/            ← 외부 데이터 형태 (JSON 등)
└── repository/     ← 데이터 관리자
```
**역할**: 외부에서 데이터를 가져와서 앱이 이해할 수 있는 형태로 변환

### **2층 (Domain Layer) - 핵심 비즈니스 로직**
```
lib/domain/
├── entity/         ← 핵심 데이터 모델
├── repository/     ← 데이터 접근 규칙 (인터페이스)
└── usecase/       ← 비즈니스 로직
```
**역할**: 앱의 핵심 규칙과 로직을 담당 (가장 중요한 층!)

### **3층 (Presentation Layer) - 사용자 인터페이스**
```
lib/presentation/
├── pages/          ← 화면들
├── widgets/        ← 재사용 가능한 UI 컴포넌트
└── providers/      ← 상태 관리
```
**역할**: 사용자가 보는 화면과 상호작용

## 🎯 각 파일별 역할

### **📁 Data Layer (데이터 계층)**

#### **1. `movie_data_source.dart`** 
```dart
abstract interface class MovieDataSource {
  Future<List<MovieDto>> fetchMovies();
}
```
**역할**: 데이터를 가져오는 방법을 정의하는 **계약서**
- 실제로 어떻게 데이터를 가져올지는 정하지 않음
- "영화 데이터를 가져와야 한다"는 규칙만 정의
- 나중에 API, 파일, 데이터베이스 등 다양한 방법으로 구현 가능

#### **2. `movie_asset_data_source_impl.dart`**
```dart
class MovieAssetDataSourceImpl implements MovieDataSource
```
**역할**: 실제로 assets 폴더의 JSON 파일에서 데이터를 가져오는 **구현체**
- `MovieDataSource` 계약서를 실제로 구현
- `assets/movies.json` 파일을 읽어서 `MovieDto` 리스트로 변환
- 테스트할 때는 가짜 객체로 대체 가능

#### **3. `movie_dto.dart`**
```dart
class MovieDto {
  MovieDto.fromJson(Map<String, dynamic> map)
  Map<String, dynamic> toJson()
}
```
**역할**: 외부 데이터 형태를 앱이 이해할 수 있게 변환하는 **번역기**
- JSON 데이터를 Dart 객체로 변환 (`fromJson`)
- Dart 객체를 JSON으로 변환 (`toJson`)
- 외부 API나 파일의 데이터 구조와 일치

#### **4. `movie_repository_impl.dart`**
```dart
class MovieRepositoryImpl implements MovieRepository {
  @override
  Future<List<Movie>> fetchMovies() async {
    final result = await _movieDataSource.fetchMovies();
    return result.map((e) => Movie(...)).toList();
  }
}
```
**역할**: `MovieRepository` 계약서를 실제로 구현하는 **구현체**
- `MovieDataSource`에서 `MovieDto`를 가져옴
- `MovieDto`를 `Movie` 엔티티로 변환
- 데이터 변환 로직을 담당

### **📁 Domain Layer (도메인 계층)**

#### **5. `movie.dart`**
```dart
class Movie {
  final String title;
  final String released;
  // ... 기타 필드들
}
```
**역할**: 앱의 핵심 데이터 모델인 **엔티티**
- 외부 데이터와 독립적인 순수한 Dart 클래스
- 비즈니스 로직에서 사용하는 데이터 구조
- JSON, API 등 외부 형태와 무관하게 앱 내부에서 사용

#### **6. `movie_repository.dart`**
```dart
abstract interface class MovieRepository {
  Future<List<Movie>> fetchMovies();
}
```
**역할**: 데이터 접근 방법을 정의하는 **중간 계약서**
- `MovieDataSource`와 `Movie` 엔티티 사이의 중간자
- "영화 데이터를 가져와서 Movie 엔티티로 변환해야 한다"는 규칙 정의

#### **7. `fetch_movies_usecase.dart`**
```dart
class FetchMoviesUsecase {
  Future<List<Movie>> execute() async {
    return await _movieRepository.fetchMovies();
  }
}
```
**역할**: 특정 비즈니스 기능을 수행하는 **작업 수행자**
- "영화 목록을 가져오기"라는 구체적인 작업을 담당
- 복잡한 비즈니스 로직이 있다면 여기에 작성
- 현재는 단순하지만 나중에 필터링, 정렬 등의 로직 추가 가능

### **🖥️ Presentation Layer (표현 계층)**

#### **8. `providers.dart`**
```dart
final _movieDataSourceProvider = Provider<MovieDataSource>((ref) {
  return MovieAssetDataSourceImpl(rootBundle);
});

final fetchMoviesUsecaseProvider = Provider((ref) {
  final movieRepo = ref.read(_movieRepositoryProvider);
  return FetchMoviesUsecase(movieRepo);
});
```
**역할**: 모든 객체들을 연결하고 제공하는 **공급자**
- 의존성 주입(Dependency Injection)을 담당
- 각 계층의 객체들을 올바른 순서로 생성하고 연결
- 테스트할 때 쉽게 가짜 객체로 교체 가능

#### **9. `movie_list_view_model.dart`**
```dart
class MovieListViewModel extends Notifier<List<Movie>> {
  Future<void> fetchMovies() async {
    final fetchMoviesUsecase = ref.read(fetchMoviesUsecaseProvider);
    final result = await fetchMoviesUsecase.execute();
    state = result;
  }
}
```
**역할**: UI와 비즈니스 로직 사이의 **중간 관리자**
- `FetchMoviesUsecase`를 호출해서 데이터 가져오기
- 가져온 데이터를 상태로 관리
- UI가 이 상태를 구독해서 화면 업데이트

#### **10. `movie_list_page.dart`**
```dart
class MovieListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final movieList = ref.watch(movieListViewModelProvider);
      // ... UI 코드
    });
  }
}
```
**역할**: 사용자가 실제로 보는 **화면**
- `MovieListViewModel`의 상태를 구독
- 영화 목록을 ListView로 표시
- 사용자와의 상호작용 처리

## 🔄 데이터 흐름

### **영화 데이터가 앱을 거쳐가는 과정:**

1. **외부 데이터** (JSON) → `MovieDto`로 변환
2. **DTO** → `Movie` 엔티티로 변환  
3. **엔티티** → `Usecase`에서 비즈니스 로직 처리
4. **결과** → `ViewModel`에서 상태 관리
5. **최종** → `UI`에 표시

## 🔄 전체 흐름 요약

```
UI → ViewModel → Usecase → Repository → DataSource → JSON 파일
  ↑                                                           ↓
  ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ←
```

### **상세 과정:**

1. **UI** (`MovieListPage`) → **ViewModel** (`MovieListViewModel`) 호출
2. **ViewModel** → **Usecase** (`FetchMoviesUsecase`) 호출  
3. **Usecase** → **Repository** (`MovieRepositoryImpl`) 호출
4. **Repository** → **DataSource** (`MovieAssetDataSourceImpl`) 호출
5. **DataSource** → JSON 파일 읽기 → **DTO** (`MovieDto`) 변환
6. **Repository** → **DTO**를 **Entity** (`Movie`)로 변환
7. **Usecase** → 결과 반환
8. **ViewModel** → 상태 업데이트
9. **UI** → 화면 새로고침

## 💡 핵심 포인트

- **각 파일은 하나의 명확한 책임**만 가짐
- **의존성은 안쪽으로만** 향함 (Domain → Data, Presentation)
- **테스트와 유지보수가 쉬움**
- **코드가 깔끔하고 이해하기 쉬움**

## 🔧 인터페이스를 만드는 이유

### **1. 테스트하기 쉽게 만들기**
```dart
// 테스트용 가짜 객체
class MockMovieDataSource implements MovieDataSource {
  @override
  Future<List<MovieDto>> fetchMovies() async {
    return [MovieDto(title: "테스트 영화", released: "2024", ...)];
  }
}
```

### **2. 다양한 구현체로 쉽게 교체**
```dart
// 현재: JSON 파일에서 읽기
class MovieAssetDataSourceImpl implements MovieDataSource { ... }

// 나중에: API 서버에서 읽기
class MovieApiDataSourceImpl implements MovieDataSource { ... }

// 또는: 데이터베이스에서 읽기
class MovieDatabaseDataSourceImpl implements MovieDataSource { ... }
```

### **3. 의존성 주입으로 쉽게 교체**
```dart
// providers.dart에서
final movieDataSourceProvider = Provider<MovieDataSource>((ref) {
  // 개발 환경: JSON 파일
  if (kDebugMode) {
    return MovieAssetDataSourceImpl(rootBundle);
  }
  // 프로덕션 환경: API 서버
  else {
    return MovieApiDataSourceImpl(httpClient);
  }
});
```

## 📝 수정 vs 추가의 차이

### **기능 교체 시 (한 곳만 수정):**
```dart
// providers.dart만 수정
final movieDataSourceProvider = Provider<MovieDataSource>((ref) {
  return MovieApiDataSourceImpl(httpClient); // JSON → API
});
```

### **기능 추가 시 (여러 곳 수정):**
```dart
// 1. 인터페이스에 메서드 추가
abstract interface class MovieDataSource {
  Future<List<MovieDto>> fetchMovies();
  Future<MovieDto> fetchMovieById(String id); // 새로 추가
}

// 2. 구현체에 메서드 구현
class MovieAssetDataSourceImpl implements MovieDataSource {
  @override
  Future<MovieDto> fetchMovieById(String id) async { ... } // 새로 구현
}

// 3. Repository 인터페이스에 메서드 추가
abstract interface class MovieRepository {
  Future<Movie> fetchMovieById(String id); // 새로 추가
}

// 4. Repository 구현체에 메서드 구현
class MovieRepositoryImpl implements MovieRepository {
  @override
  Future<Movie> fetchMovieById(String id) async { ... } // 새로 구현
}

// 5. Usecase 추가
class FetchMovieByIdUsecase {
  Future<Movie> execute(String id) async {
    return await _movieRepository.fetchMovieById(id);
  }
}

// 6. ViewModel에 메서드 추가
class MovieListViewModel extends Notifier<List<Movie>> {
  Future<void> fetchMovieById(String id) async { ... } // 새로 추가
}

// 7. UI에 기능 추가
class MovieListPage extends StatelessWidget {
  // 새로 추가된 UI 요소들...
}
```
