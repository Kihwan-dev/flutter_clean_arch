import 'package:flutter/material.dart';
import 'package:flutter_clean_arch/presentation/pages/movie_list/movie_list_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MovieListPage(),
    );
  }
}
