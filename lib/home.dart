// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ConfettiController _confettiController1 = ConfettiController();
  ConfettiController _confettiController2 = ConfettiController();

  @override
  void initState() {
    super.initState();
    _confettiController1 =
        ConfettiController(duration: Duration(milliseconds: 1500));
    _confettiController2 =
        ConfettiController(duration: Duration(milliseconds: 1500));
  }

  @override
  void dispose() {
    _confettiController1.dispose();
    _confettiController2.dispose();
    super.dispose();
  }

  int firstDice = 1;
  int secondDice = 1;
  int thirdDice = 1;

  int currPoints = 0;
  int currCoin = 1000;

  var audioPathForButtonPressed = "assets/audios/button-click.mp3";
  var audioPathForCrowdCheers = "assets/audios/crowd-cheers.mp3";
  Color myColor =
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  void rollDice() {
    setState(() {
      currCoin -= 10;
      myColor =
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
      firstDice = Random().nextInt(6) + 1;
      secondDice = Random().nextInt(6) + 1;
      thirdDice = Random().nextInt(6) + 1;

      if (firstDice == secondDice && secondDice == thirdDice) {
        currPoints += 100;
      }

      if (currPoints >= 1000) {
        // You win
        _confettiController1.play();
        Future.delayed(Duration(seconds: 5), () {
          _confettiController1.stop();
        });
      }

      if (currPoints < 1000 && currCoin < 0) {
        // You Lose
        currCoin = 1000;
        currPoints = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor,
      appBar: AppBar(
          title: Text("Dream Dice"),
          backgroundColor: Color(0xff4A241C),
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Color(0xff4A241C))),
      body: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController1,
            shouldLoop: true,
            blastDirection: pi / 12,
            colors: [
              Colors.red,
              Colors.green,
              Colors.yellow,
              Colors.purpleAccent,
              Colors.brown,
              Colors.deepPurple,
              Colors.indigo,
              Colors.pink,
              Colors.orange,
              Colors.teal,
            ],
            blastDirectionality: BlastDirectionality.directional,
            numberOfParticles: 20,
            gravity: 1,
            emissionFrequency: 0.1,
            displayTarget: false,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Target: 1000 \n  Score: $currPoints \n Coin Avl: $currCoin ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                            // height: 200,
                            // width: 200,
                            image: AssetImage(
                                'assets/images/dice-png-$firstDice.png'),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                            image: AssetImage(
                                'assets/images/dice-png-$secondDice.png')),
                      )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                              image: AssetImage(
                                  'assets/images/dice-png-$thirdDice.png')),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: RaisedButton(
                      onPressed: rollDice,
                      child: Text(
                        "Click To Play",
                        style: TextStyle(fontSize: 25),
                      ),
                      color: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
