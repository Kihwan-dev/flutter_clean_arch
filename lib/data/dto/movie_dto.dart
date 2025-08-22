//  {
//   "title": "Avatar",
//   "released": "18 Dec 2009",
//   "runtime": "162 min",
//   "director": "James Cameron",
//   "actors": "Sam Worthington, Zoe Saldana, Sigourney Weaver, Stephen Lang",
//   "poster": "https://ia.media-imdb.com/images/M/MV5BMTYwOTEwNjAzMl5BMl5BanBnXkFtZTcwODc5MTUwMw@@._V1_SX300.jpg",
//   "imdbRating": "7.9"
// },

class MovieDto {
  MovieDto({
    required this.title,
    required this.released,
    required this.runtime,
    required this.director,
    required this.actors,
    required this.poster,
  });

  final String title;
  final String released;
  final String runtime;
  final String director;
  final String actors;
  final String poster;

  MovieDto.fromJson(Map<String, dynamic> map)
      : this(
          title: map["title"],
          released: map["released"],
          runtime: map["runtime"],
          director: map["director"],
          actors: map["actors"],
          poster: map["poster"],
        );

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "released": released,
      "runtime": runtime,
      "director": director,
      "actors": actors,
      "poster": poster,
    };
  }
}
