import 'package:flutter_clean_arch/data/dto/movie_dto.dart';

abstract interface class MovieDataSource {
  // 메서드 정의만
  // 실제 구현은 이 인터페이스를 implementation해서 구현
  // 레포지토리에서는 이 인터페이스를 참조
  // 이러면 실제 구현된 내용이 수정이 돼도 인터페이스는 수정이 안돼서 레포지토리는 수정 할 필요 없게 의존성 끊음
  Future<List<MovieDto>> fetchMovies();
}
