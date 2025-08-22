import 'package:flutter_clean_arch/domain/entity/movie.dart';
import 'package:flutter_clean_arch/presentation/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1 상태 클래스
// 영화 리스트 List<Movie>

class MovieListViewModel extends Notifier<List<Movie>> {
  @override
  List<Movie> build() {
    fetchMovies();
    return [];
  }

  Future<void> fetchMovies() async {
    final fetchMoviesUsecase = ref.read(fetchMoviesUsecaseProvider);
    final result = await fetchMoviesUsecase.execute();
    state = result;
  }
}

final movieListViewModelProvider = NotifierProvider<MovieListViewModel, List<Movie>>(
  () {
    return MovieListViewModel();
  },
);
