import 'dart:async';
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
  var collision = List.generate(6, (i) => List.filled(9, 0), growable: false);

  updateCollision() {
    collision = List.generate(6, (i) => List.filled(9, 0), growable: false);
    for (int i = 0; i < children.length; i++) {
      Tile t = children[i] as Tile;
      collision[t.col][t.clicks] = 1;
    }
    print(collision);
  }

  int checkCollision(Tile t, String action) {
    switch (action) {
      case "left":
        if (t.col != 0 && collision[t.col - 1][t.clicks] == 0) {
          return 0;
        }
        return 1;
      case "right":
        if (t.col != 5 && collision[t.col + 1][t.clicks] == 0) {
          return 0;
        }
        return 1;
      case "down":
        if (t.clicks != 8 && collision[t.col][t.clicks + 1] == 0) {
          return 0;
        }
        return 1;
      case "drop":
        int curr = t.clicks;
        for (int i = curr + 1; i < 9; i++) {
          if (collision[t.col][i] != 0) return i - 1;
        }
        return 8;
      default:
        return -1;
    }
  }

  callback() {
    setState(() {});
  }

  Timer? clock;

  @override
  Widget build(BuildContext context) {
    Widget topSection = SizedBox(
      width: 308,
      height: 458,
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
                    children = children + [Tile(0)];
                    updateCollision();
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
                if (checkCollision(banana, "left") == 0) {
                  gameState.moveLeft();
                  updateCollision();
                }
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
                if (checkCollision(banana, "right") == 0) {
                  gameState.moveRight();
                  updateCollision();
                }
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
                    if (checkCollision(banana, "down") == 0) {
                      gameState.moveDown();
                      updateCollision();
                    }
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
            icon: const Icon(Icons.settings_power),
            onPressed: () => print("reset butn"),
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
              int loc = checkCollision(banana, "drop");
              gameState.dropBlock(loc);
              updateCollision();
            }),
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
          child: IconButton(
            color: Colors.blue,
            iconSize: 48.00,
            icon: const Icon(Icons.circle),
            onPressed: () {
              setState(() {});
            },
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
      height: 190,
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

  int type = 0;
  Tile(this.col);

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
          width: 50,
          height: 50,
          left: widget.col * 50,
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
      widget.clicks = (widget.clicks == 8) ? 8 : widget.clicks + 1;
    });
  }

  void dropBlock(int loc) {
    setState(() {
      widget.clicks = loc;
    });
  }

  void moveLeft() {
    setState(() {
      int testcol = widget.col - 1;
      if (testcol >= 0) {
        widget.col -= 1;
      }
    });
  }

  void moveRight() {
    setState(() {
      int testcol = widget.col + 1;
      if (testcol <= 5) {
        widget.col += 1;
      }
    });
  }
}
