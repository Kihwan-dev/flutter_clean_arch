import 'package:flutter_clean_arch/domain/entity/movie.dart';

abstract interface class MovieRepository {
  Future<List<Movie>> fetchMovies();
}
