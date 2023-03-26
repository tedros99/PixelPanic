import 'dart:math';

import 'package:flutter/material.dart';

var gameState = _TileState();

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GameState();
}

class _GameState extends State<GamePage> {
  var children = <Widget>[];
  var currTile = 0;

  callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget topSection = SizedBox(
      width: 300,
      height: 450,
      child: Card(
          color: const Color.fromARGB(255, 189, 199, 144),
          child: Stack(
            children: children,
          )),
    );

    Widget dpad = GridView.count(
      crossAxisCount: 3,
      children: [
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        ),
        Container(
            color: Colors.black,
            child: RotatedBox(
              quarterTurns: 1,
              child: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.arrow_left),
                onPressed: () {
                  setState(() {
                    children = children + [Tile(currTile++)];
                  });
                },
              ),
            )),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        ),
        Container(
          color: Colors.black,
          child: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_left),
            onPressed: () {
              setState(() {
                //print(currTile);
                Tile banana = children[currTile - 1] as Tile;
                gameState.moveLeft();
              });
            },
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        ),
        Container(
          color: Colors.black,
          child: IconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_right),
            onPressed: () {
              setState(() {
                //print(currTile);
                Tile banana = children[currTile - 1] as Tile;
                gameState.moveRight();
              });
            },
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        ),
        Container(
            color: Colors.black,
            child: RotatedBox(
              quarterTurns: 3,
              child: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.arrow_left),
                onPressed: () {
                  setState(() {
                    //print(currTile);
                    Tile banana = children[currTile - 1] as Tile;
                    gameState.moveDown();
                  });
                },
              ),
            )),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        )
      ],
    );

    Widget swapBtn = GridView.count(
      crossAxisCount: 3,
      children: [
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        ),
        Container(
          color: Colors.grey,
          child: IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => print("swap butn"),
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        )
      ],
    );

    Widget abBtn = GridView.count(
      crossAxisCount: 2,
      children: [
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
          child: IconButton(
            color: Colors.red,
            iconSize: 48.00,
            icon: const Icon(Icons.circle),
            onPressed: (() {
              Tile banana = children[currTile - 1] as Tile;
              gameState.dropBlock();
            }),
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
          child: IconButton(
            color: Colors.blue,
            iconSize: 48.00,
            icon: const Icon(Icons.circle),
            onPressed: () => print("swap butn"),
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
        ),
      ],
    );

    Widget controls = GridView.count(
      crossAxisCount: 3,
      children: [
        Container(
          color: Colors.white,
          child: dpad,
        ),
        Container(
          color: Colors.white,
          child: swapBtn,
        ),
        Container(
          color: Colors.white,
          child: abBtn,
        )
      ],
    );

    Widget bottomSection = SizedBox(
      width: 350,
      height: 200,
      child: controls,
    );
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 204, 214, 221),
      ),
      title: 'Flutter layout demo',
      home: Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 32),
          alignment: Alignment.center,
          child: Column(children: [topSection, bottomSection]),
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  int col = 0;
  int clicks = 0;
  Tile(this.col);

  void setColumn(int column) {
    col = column;
  }

  void clickThing() {
    clicks++;
  }

  @override
  State<Tile> createState() {
    gameState = _TileState();
    return gameState;
  }
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    //int clicks = widget.clicks;
    return SizedBox(
        child: Stack(children: <Widget>[
      AnimatedPositioned(
          width: 45,
          height: 45,
          left: widget.col * 45,
          top: (widget.clicks < 8) ? 0 + widget.clicks * 50 : 400,
          duration: const Duration(seconds: 0),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  //widget.col = widget.col + 1;
                  widget.clicks += 1;
                });
              },
              child: Container(
                  color: Colors.blue, child: const Center(child: Text("a")))))
    ]));
  }

  void moveDown() {
    setState(() {
      widget.clicks += 1;
    });
  }

  void dropBlock() {
    setState(() {
      widget.clicks = 8;
    });
  }

  void moveLeft() {
    setState(() {
      widget.col -= 1;
    });
  }

  void moveRight() {
    setState(() {
      widget.col += 1;
    });
  }
}
