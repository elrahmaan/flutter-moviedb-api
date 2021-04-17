import 'dart:ffi';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http_request/pages/movie_detail.dart';
import 'package:http_request/services/http_service.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  int moviesCount;
  List movies;
  HttpService service;

  Future initialize() async {
    movies = [];
    movies = await service.getPopularMovies();
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  @override
  void initState() {
    service = HttpService();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("NSC ",
                style: TextStyle(color: Colors.orangeAccent, fontSize: 25)),
            Text(
              "Movie",
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: Icon(
              Icons.short_text,
              color: Colors.white,
              size: 33,
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.black87,
        child: ListView.builder(
          itemCount: (this.moviesCount == null) ? 0 : this.moviesCount,
          itemBuilder: (context, int position) {
            return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 27,
                  backgroundImage: NetworkImage(
                      'https://image.tmdb.org/t/p/original' +
                          movies[position].posterPath.toString()),
                ),
                title: Text(movies[position].title),
                subtitle:
                    Text('Rating = ' + movies[position].voteAverage.toString()),
                onTap: () {
                  MaterialPageRoute route = MaterialPageRoute(
                      builder: (_) => MovieDetail(movies[position]));
                  Navigator.push(context, route);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
