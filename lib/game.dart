import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:matrix2d/matrix2d.dart';

import 'package:shared_preferences/shared_preferences.dart';

var gameState = _TileState();

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GameState();
}

class _GameState extends State<GamePage> {
  var children = <Widget>[];
  var currTile = 0;
  var collision = List.generate(6, (i) => List.filled(9, 0), growable: false);
  var children2 = <Widget>[];
  var currPattern = -1;
  var failed = false;
  var success = false;

  var patternList = [
    [
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 1, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0]
    ],
    [
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 1, 1, 0, 0],
      [0, 0, 0, 0, 1, 1, 1, 1, 1],
      [0, 0, 0, 0, 1, 0, 1, 1, 0],
      [0, 0, 0, 0, 1, 0, 1, 1, 1],
      [0, 0, 0, 0, 0, 0, 0, 0, 0]
    ],
    [
      [1, 1, 0, 0, 0, 0, 0, 1, 1],
      [1, 0, 1, 0, 0, 0, 1, 0, 1],
      [1, 0, 0, 1, 0, 1, 0, 0, 1],
      [1, 0, 0, 0, 1, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 1]
    ],
    [
      [0, 1, 0, 1, 0, 0, 0, 0, 0],
      [0, 1, 1, 1, 1, 1, 1, 1, 1],
      [0, 1, 0, 1, 0, 0, 0, 0, 0],
      [0, 1, 0, 1, 0, 0, 0, 0, 0],
      [0, 1, 1, 1, 1, 1, 1, 1, 1],
      [0, 1, 0, 1, 0, 0, 0, 0, 0]
    ],
    [
      [1, 1, 1, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 1, 0, 0, 0, 0, 0, 0],
      [1, 1, 1, 0, 0, 0, 0, 0, 0]
    ],
  ];

  displayPattern() {
    children2.clear();
    var ranP = Random().nextInt(patternList.length);
    var pattern = patternList[ranP];
    currPattern = ranP;
    for (int i = 0; i < pattern.length; i++) {
      for (int j = 0; j < pattern[i].length; j++) {
        if (pattern[i][j] == 1) {
          children2.add(PatternTile(i, j, 0, Color.fromRGBO(0, 0, 0, 0.5)));
        }
      }
    }
  }

  setScores(name, score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    setState(() {
      if (prefs.getStringList('scores') == null) {
        prefs.setStringList('scores', [score]);
        prefs.setStringList('names', [name]);
      } else {
        var scores = (prefs.getStringList('scores') ?? ['']);
        var names = (prefs.getStringList('names') ?? ['']);
        if (scores.length == 10) {
          scores.removeLast();
          names.removeLast();
        }
        scores.insert(0, score);
        names.insert(0, name);
        prefs.setStringList('scores', scores);
        prefs.setStringList('names', names);
      }
      print(prefs.getStringList('scores'));
    });
  }

  checkTile(Tile t) {
    var p = patternList[currPattern];
    var value = p[t.col][t.clicks];
    if (value == 0) {
      failed = true;
    } else if (collision.sum == p.sum) {
      success = true;
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text("Input your name to save your score: "),
                content: TextField(
                  onSubmitted: (value) =>
                      setScores(value, timetaken.toString()),
                ),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text("Save Score"))
                ],
              ));
    }
  }

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

  Timer? timer;

  int timetaken = 0;

  bool started = false;

  @override
  Widget build(BuildContext context) {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (started && failed != true && success != true) {
          timetaken++;
        }
      });
    });
    Widget topSection = SizedBox(
      width: 308,
      height: 458,
      child: Card(
          color: const Color.fromARGB(255, 189, 199, 144),
          child: Stack(
            children: children + children2,
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
                onPressed: () {},
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
              if (started && failed != true && success != true) {
                Tile banana = children[currTile - 1] as Tile;
                if (checkCollision(banana, "left") == 0) {
                  gameState.moveLeft();
                  updateCollision();
                }
              }
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
              if (started && failed != true && success != true) {
                Tile banana = children[currTile - 1] as Tile;
                if (checkCollision(banana, "right") == 0) {
                  gameState.moveRight();
                  updateCollision();
                }
              }
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
                  if (started && failed != true && success != true) {
                    Tile banana = children[currTile - 1] as Tile;
                    if (checkCollision(banana, "down") == 0) {
                      gameState.moveDown();
                      updateCollision();
                    }
                  }
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
              icon: const Icon(Icons.power_settings_new),
              onPressed: () {
                setState(() {
                  if (!started) {
                    displayPattern();
                    children = children + [Tile(3, ++currTile, Colors.blue)];
                    started = true;
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => GamePage()));
                  }
                });
              }),
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
              if (started && failed != true && success != true) {
                Tile banana = children[currTile - 1] as Tile;
                int loc = checkCollision(banana, "drop");
                gameState.dropBlock(loc);
                updateCollision();
              }
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
              setState(() {
                checkTile(children[currTile - 1] as Tile);
                if (failed != true && success != true) {
                  print(gameState);
                  children = children + [Tile(3, ++currTile, Colors.blue)];
                  updateCollision();
                }
              });
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

    int min = (timetaken / 60).floor();
    int sec = (timetaken % 60);
    String minutes = min.toString().length <= 1 ? "0$min" : "$min";
    String seconds = sec.toString().length <= 1 ? "0$sec" : "$sec";
    String words = "Time: " + minutes + ":" + seconds;

    Widget scoreLabel = SizedBox(
      width: 350,
      height: 50,
      child: Card(
        color: Color.fromARGB(255, 0, 0, 0),
        child: Text(
          success
              ? "You Win!"
              : failed
                  ? "Game Over!"
                  : "Time: " + minutes + ":" + seconds,
          style: TextStyle(color: Colors.white, fontSize: 25),
          textAlign: TextAlign.center,
        ),
      ),
    );

    Widget bottomSection = SizedBox(
      width: 350,
      height: 140,
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
          child: Column(children: [topSection, scoreLabel, bottomSection]),
        ),
      ),
    );
  }
}

class PatternTile extends StatefulWidget {
  int col = 0;
  int row = 0;
  int id;
  Color tileColor;

  int type = 0;
  PatternTile(this.col, this.row, this.id, this.tileColor);

  @override
  _PatternState createState() {
    return _PatternState();
  }
}

class _PatternState extends State<PatternTile> {
  @override
  Widget build(BuildContext context) {
    //int clicks = widget.clicks;
    return SizedBox(
        child: Stack(children: <Widget>[
      AnimatedPositioned(
          width: 50,
          height: 50,
          left: widget.col * 50,
          top: (widget.row < 8) ? 0 + widget.row * 50 : 400,
          duration: const Duration(seconds: 0),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  //widget.col = widget.col + 1;
                  widget.row += 1;
                });
              },
              child: Container(color: widget.tileColor)))
    ]));
  }
}

class Tile extends StatefulWidget {
  int col = 0;
  int clicks = 0;
  int id;
  Color tileColor;

  int type = 0;
  Tile(this.col, this.id, this.tileColor);

  void setColumn(int column) {
    col = column;
  }

  void clickThing() {
    clicks++;
  }

  @override
  _TileState createState() {
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
                  color: widget.tileColor,
                  child: const Center(child: Icon(Icons.circle)))))
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
