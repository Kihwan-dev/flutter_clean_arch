import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_clean_arch/data/data_source/movie_data_source.dart';
import 'package:flutter_clean_arch/data/dto/movie_dto.dart';

class MovieAssetDataSourceImpl implements MovieDataSource {
  MovieAssetDataSourceImpl(this._assetBundle);

  // 예를 들어 파이어베이스 테스트를 할 때 이 멤버 변수는 가짜 객체로 전달해서 테스트 가능
  final AssetBundle _assetBundle;

  @override
  Future<List<MovieDto>> fetchMovies() async {
    final jsonString = await _assetBundle.loadString("assets/movies.json");
    final list = jsonDecode(jsonString);
    return List.from(list).map((e) => MovieDto.fromJson(e)).toList();
  }
}
