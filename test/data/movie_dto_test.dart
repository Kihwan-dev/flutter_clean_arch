import 'dart:convert';

import 'package:flutter_clean_arch/data/dto/movie_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    "MovieDTO : fromJson test",
    () {
      const sampleJsonString = """
 {
  "title": "Avatar",
  "released": "18 Dec 2009",
  "runtime": "162 min",
  "director": "James Cameron",
  "actors": "Sam Worthington, Zoe Saldana, Sigourney Weaver, Stephen Lang",
  "poster": "https://ia.media-imdb.com/images/M/MV5BMTYwOTEwNjAzMl5BMl5BanBnXkFtZTcwODc5MTUwMw@@._V1_SX300.jpg",
  "imdbRating": "7.9"
 }
""";
      final map = jsonDecode(sampleJsonString);
      final movieDto = MovieDto.fromJson(map);
      expect(movieDto.title, "Avatar");
      expect(movieDto.released, "18 Dec 2009");
      expect(movieDto.runtime, "162 min");
      expect(movieDto.director, "James Cameron");
      expect(movieDto.actors, "Sam Worthington, Zoe Saldana, Sigourney Weaver, Stephen Lang");
      expect(movieDto.poster, "https://ia.media-imdb.com/images/M/MV5BMTYwOTEwNjAzMl5BMl5BanBnXkFtZTcwODc5MTUwMw@@._V1_SX300.jpg");
    },
  );
}
