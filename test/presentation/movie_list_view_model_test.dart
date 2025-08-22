import 'package:flutter_clean_arch/domain/entity/movie.dart';
import 'package:flutter_clean_arch/domain/usecase/fetch_movies_usecase.dart';
import 'package:flutter_clean_arch/presentation/pages/movie_list/movie_list_view_model.dart';
import 'package:flutter_clean_arch/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFetchMoviesUseCase extends Mock implements FetchMoviesUsecase {}

void main() {
  ProviderContainer? providerContainer;

  setUp(
    () {
      final fetchMoviesUsecaseProviderOverride = fetchMoviesUsecaseProvider.overrideWith(
        (ref) {
          return MockFetchMoviesUseCase();
        },
      );
      providerContainer = ProviderContainer(
        overrides: [
          fetchMoviesUsecaseProviderOverride,
        ],
      );
      addTearDown(providerContainer!.dispose);
    },
  );

  test(
    "MovieListViewModel test : state update after fetchMovies",
    () async {
      when(() => providerContainer!.read(fetchMoviesUsecaseProvider).execute()).thenAnswer(
        (invocation) async => [
          Movie(
            title: "title",
            released: "released",
            runtime: "runtime",
            director: "director",
            actors: "actors",
            poster: "poster",
          ),
        ],
      );
      // 1. 최초 상태 빈 배열
      final stateBefore = providerContainer!.read(movieListViewModelProvider);
      expect(stateBefore.length, 0);

      // 2. fetchMovie 호출한 뒤 => 상태 사이즈 1
      await providerContainer!.read(movieListViewModelProvider.notifier).fetchMovies();

      final stateAfter = providerContainer!.read(movieListViewModelProvider);
      expect(stateAfter.isEmpty, false);
      expect(stateAfter.length, 1);
      expect(stateAfter.first.title, "title");
    },
  );
}
