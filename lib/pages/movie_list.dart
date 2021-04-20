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
                style: TextStyle(color: Color(0xFFf4C10F), fontSize: 25)),
            Text("Movie", style: TextStyle(fontSize: 25)),
          ],
        ),
        backgroundColor: Color(0xFF151C26),
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
      backgroundColor: Color(0xFF151C26),
      body: ListView(
        children: <Widget>[
          //BANNER HERO IMAGE
          Container(
            height: 220.0,
            child: PageIndicatorContainer(
              align: IndicatorAlign.bottom,
              //page indicator berjumlah menyesuaikan data yang diambil (5 data)
              length: movies.take(5).length,
              indicatorSpace: 8.0,
              padding: const EdgeInsets.all(5.0),
              indicatorColor: Color(0xFF5a606b),
              indicatorSelectorColor: Color(0xFFf4C10F),
              shape: IndicatorShape.circle(size: 6.0),
              child: PageView.builder(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                //mengambil 5 data
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
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: [
                                  0.0,
                                  0.9
                                ],
                                colors: [
                                  Color(0xFF151C26).withOpacity(1.0),
                                  Color(0xFF151C26).withOpacity(0.0)
                                ]),
                          ),
                        ),
                        Positioned(
                            bottom: 30.0,
                            child: Container(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
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
                                  Row(
                                    children: [
                                      //icon rating
                                      ...List.generate(
                                        5,
                                        (index) => Icon(
                                          Icons.star,
                                          color: (index <
                                                  (movies[position]
                                                              .voteAverage /
                                                          2)
                                                      .floor())
                                              ? Colors.yellow
                                              : Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        padding: EdgeInsets.only(
                                            top: 2,
                                            left: 3,
                                            bottom: 2,
                                            right: 3),
                                        decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(3.0),
                                              topRight: Radius.circular(3.0),
                                              bottomLeft: Radius.circular(3.0),
                                              bottomRight: Radius.circular(3.0),
                                            )),
                                        child: Text(
                                          movies[position]
                                              .voteAverage
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                    ],
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
                            Row(
                              children: [
                                //icon rating
                                ...List.generate(
                                  5,
                                  (index) => Icon(
                                    Icons.star,
                                    size: 15,
                                    color: (index <
                                            (movies[position].voteAverage / 2)
                                                .floor())
                                        ? Colors.yellow
                                        : Color(0xFFfafafa),
                                  ),
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 2, left: 3, bottom: 2, right: 3),
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3.0),
                                        topRight: Radius.circular(3.0),
                                        bottomLeft: Radius.circular(3.0),
                                        bottomRight: Radius.circular(3.0),
                                      )),
                                  child: Text(
                                    movies[position].voteAverage.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ],
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

          // NOW SHOWING
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    "Now Showing",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 170,
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    //mengambil 5 data
                    itemCount: movies.take(5).length,
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
                              height: 140,
                              width: 110,
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
                              width: 110,
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
    );
  }
}
