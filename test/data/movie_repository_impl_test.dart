import 'package:flutter_clean_arch/data/data_source/movie_data_source.dart';
import 'package:flutter_clean_arch/data/dto/movie_dto.dart';
import 'package:flutter_clean_arch/data/repository/movie_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieDataSource extends Mock implements MovieDataSource {}

void main() {
  MockMovieDataSource? mockMovieDataSource;
  MovieRepositoryImpl? movieRepositoryImpl;
  setUp(
    () {
      mockMovieDataSource = MockMovieDataSource();
      movieRepositoryImpl = MovieRepositoryImpl(mockMovieDataSource!);
    },
  );

  test("MovieRepositoryImpl test : fetchMovies", () async {
    // Mock 클래스 세팅
    when(() => mockMovieDataSource!.fetchMovies()).thenAnswer((invocation) async => [
          MovieDto(
            title: "title",
            released: "released",
            runtime: "runtime",
            director: "director",
            actors: "actors",
            poster: "poster",
          ),
        ]);
    final result = await movieRepositoryImpl!.fetchMovies();
    expect(result.length, 1);
    expect(result.first.title, "title");
  });
}
