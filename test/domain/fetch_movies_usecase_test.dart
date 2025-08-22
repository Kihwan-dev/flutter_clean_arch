import 'package:flutter_clean_arch/domain/entity/movie.dart';
import 'package:flutter_clean_arch/domain/repository/movie_repository.dart';
import 'package:flutter_clean_arch/domain/usecase/fetch_movies_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  //
  MockMovieRepository? mockMovieRepository;
  FetchMoviesUsecase? fetchMoviesUsecase;

  setUp(
    () {
      mockMovieRepository = MockMovieRepository();
      fetchMoviesUsecase = FetchMoviesUsecase(mockMovieRepository!);
    },
  );

  test("FetchMoviesUsecase test : fetchMovies", () async {
    when(() => mockMovieRepository!.fetchMovies()).thenAnswer((invocation) async => [
          Movie(
            title: "title",
            released: "released",
            runtime: "runtime",
            director: "director",
            actors: "actors",
            poster: "poster",
          ),
        ]);
    final result = await fetchMoviesUsecase!.execute();
    expect(result.length, 1);
    expect(result.first.title, "title");
  });
}
