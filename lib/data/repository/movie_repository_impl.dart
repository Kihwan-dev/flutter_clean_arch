// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_clean_arch/data/data_source/movie_data_source.dart';
import 'package:flutter_clean_arch/domain/entity/movie.dart';
import 'package:flutter_clean_arch/domain/repository/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl(this._movieDataSource);

  final MovieDataSource _movieDataSource;

  @override
  Future<List<Movie>> fetchMovies() async {
    //
    final result = await _movieDataSource.fetchMovies();
    return result
        .map(
          (e) => Movie(
            title: e.title,
            released: e.released,
            runtime: e.runtime,
            director: e.director,
            actors: e.actors,
            poster: e.poster,
          ),
        )
        .toList();
  }
}
