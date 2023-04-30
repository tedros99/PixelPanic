import 'dart:io';

import 'package:flutter/material.dart';
import 'game.dart';
import 'rules.dart';
import 'score.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget topSection = SizedBox(
      width: 300,
      height: 450,
      child: Card(
          color: const Color.fromARGB(255, 189, 199, 144),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "PixelPanic",
                textScaleFactor: 3.0,
                style: GoogleFonts.robotoMono(),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const GamePage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 40, 43, 31),
                ),
                child: Text(
                  "PLAY",
                  style: GoogleFonts.robotoMono(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const RulesPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 40, 43, 31),
                ),
                child: Text(
                  "RULES",
                  style: GoogleFonts.robotoMono(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ScoresPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 40, 43, 31),
                ),
                child: Text(
                  "SCORES",
                  style: GoogleFonts.robotoMono(),
                ),
              ),
              ElevatedButton(
                onPressed: () => exit(0),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 40, 43, 31),
                ),
                child: Text(
                  "EXIT",
                  style: GoogleFonts.robotoMono(),
                ),
              ),
            ],
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
            onPressed: () {},
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
            onPressed: () {},
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
                onPressed: () {},
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
            onPressed: () {},
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
              onPressed: () {}),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
          child: IconButton(
              color: Colors.blue,
              iconSize: 48.00,
              icon: const Icon(Icons.circle),
              onPressed: () {}),
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
          fontFamily: 'Raleway'),
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
