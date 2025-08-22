import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/data/data_source/movie_asset_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  //
  MockAssetBundle? mockAssetBundle;
  MovieAssetDataSourceImpl? dataSource;

  setUp(
    () {
      // 테스트 하기 전에 이 함수가 호출되서
      // 세팅 진행
      mockAssetBundle = MockAssetBundle();
      dataSource = MovieAssetDataSourceImpl(mockAssetBundle!);
    },
  );

  test(
    "MovieAssetDataSourceImpl : fetchMovies return data test",
    () async {
      when(() {
        // 어떠한 상황이 발생 했을 때
        return mockAssetBundle!.loadString(any());
      }).thenAnswer(
          // 이렇게 리턴해줘라
          (_) async => """
[{
  "title": "Avatar",
  "released": "18 Dec 2009",
  "runtime": "162 min",
  "director": "James Cameron",
  "actors": "Sam Worthington, Zoe Saldana, Sigourney Weaver, Stephen Lang",
  "poster": "https://ia.media-imdb.com/images/M/MV5BMTYwOTEwNjAzMl5BMl5BanBnXkFtZTcwODc5MTUwMw@@._V1_SX300.jpg",
  "imdbRating": "7.9"
}]
 """);

      final results = await dataSource!.fetchMovies();
      expect(results.length, 1);
    },
  );
}
