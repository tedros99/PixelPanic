import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoresPage extends StatefulWidget {
  const ScoresPage({super.key});
  @override
  State<ScoresPage> createState() => _ScoreState();
}

class _ScoreState extends State<ScoresPage> {
  List<String> scores = [''];
  List<String> names = [''];

  @override
  void initState() {
    super.initState();
    loadNames();
    loadScores();
  }

  loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    setState(() {
      scores = (prefs.getStringList('scores') ?? ['']);
    });
  }

  loadNames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    setState(() {
      names = (prefs.getStringList('names') ?? ['']);
    });
  }

  @override
  Widget build(BuildContext context) {
    String txt = "Last 10 Saved Scores: \n";

    for (int i = 0; i < scores.length; i++) {
      txt += ("${scores[i]} seconds - ${names[i]}\n");
    }

    Widget topSection = SizedBox(
      width: 300,
      height: 450,
      child: Card(
          color: const Color.fromARGB(255, 189, 199, 144),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                txt,
                textScaleFactor: 1.5,
                style: GoogleFonts.robotoMono(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 40, 43, 31),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Return to Home Page',
                    style: GoogleFonts.robotoMono(),
                  ))
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
                  onPressed: () {}),
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
            onPressed: () {},
          ),
        ),
        Container(
          color: const Color.fromARGB(255, 204, 214, 221),
          child: IconButton(
            color: Colors.blue,
            iconSize: 48.00,
            icon: const Icon(Icons.circle),
            onPressed: () {},
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
