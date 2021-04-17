import 'dart:ffi';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http_request/pages/movie_detail.dart';
import 'package:http_request/services/http_service.dart';
import 'package:page_indicator/page_indicator.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  int moviesCount;
  List movies;
  HttpService service;
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);

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
        child: Column(
          children: [
            //BANNER HERO IMAGE
            Container(
              height: 220.0,
              child: PageIndicatorContainer(
                align: IndicatorAlign.bottom,
                length: movies.take(5).length,
                indicatorSpace: 8.0,
                padding: const EdgeInsets.all(5.0),
                indicatorColor: Colors.blueGrey[200],
                indicatorSelectorColor: Colors.orangeAccent,
                shape: IndicatorShape.circle(size: 6.0),
                child: PageView.builder(
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.take(5).length,
                  itemBuilder: (context, position) {
                    return InkWell(
                      onTap: () {
                        MaterialPageRoute route = MaterialPageRoute(
                            builder: (_) => MovieDetail(movies[position]));
                        Navigator.push(context, route);
                      },
                      child: Stack(
                        children: <Widget>[
                          Hero(
                            tag: movies[position].id,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 220.0,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "https://image.tmdb.org/t/p/original/" +
                                              movies[position]
                                                  .posterPath
                                                  .toString())),
                                )),
                          ),
                          Positioned(
                              bottom: 30.0,
                              child: Container(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                width: 250.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      movies[position].title,
                                      style: TextStyle(
                                          height: 1.5,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text(
                                        'Rate: ' +
                                            movies[position]
                                                .voteAverage
                                                .toString(),
                                        style: TextStyle(
                                          color: Colors.yellow,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // POPULAR MOVIE
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      "Popular Movie",
                      style: TextStyle(
                        color: Colors.white,
                        // color: Color(0xFFf4C10F),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 230,
                    margin: EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movies.length,
                      itemBuilder: (context, position) {
                        return InkWell(
                          onTap: () {
                            MaterialPageRoute route = MaterialPageRoute(
                                builder: (_) => MovieDetail(movies[position]));
                            Navigator.push(context, route);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 180,
                                width: 140,
                                margin: EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        "https://image.tmdb.org/t/p/original/" +
                                            movies[position]
                                                .posterPath
                                                .toString()),
                                  ),
                                ),
                              ),
                              Container(
                                width: 140,
                                child: Text(
                                  movies[position].title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  'Rate: ' +
                                      movies[position].voteAverage.toString(),
                                  style: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
