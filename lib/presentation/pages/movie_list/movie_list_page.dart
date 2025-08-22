import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/presentation/pages/movie_list/movie_list_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieListPage extends StatelessWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("영화 목록"),
      ),
      body: Consumer(builder: (context, ref, child) {
        final movieList = ref.watch(movieListViewModelProvider);
        return ListView.builder(
          itemCount: movieList.length,
          itemBuilder: (context, index) {
            final movie = movieList[index];
            return Container(
              height: 200,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 2 / 3,
                    child: Image.network(
                      movie.poster,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title),
                        Text(movie.released),
                        Text(movie.runtime),
                        Text(movie.director),
                        Text(movie.actors),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
