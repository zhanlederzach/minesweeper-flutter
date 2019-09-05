import 'package:flutter/material.dart';
import 'saperGame.dart';

void main() {
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saper',
      
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: StartPage(),  //SaperGame()
    );
  }
}

class StartPage extends StatefulWidget {

  @override
  _StartPageState createState() {
    return _StartPageState();
  }

}

class _StartPageState extends State<StartPage>{
  String level;
  bool isPressed;
  Color currentLevelColor = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Choose game'),
        ),
        body: new Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text('Easy'),
                onPressed: () {
                  level='Easy';
                  startGame();
                },
                splashColor: Colors.yellow,
              ),
              RaisedButton(
                child: Text('Medium'),
                onPressed: () {
                  level='Medium';
                  startGame();
                },
                splashColor: Colors.yellow,
              ),
              RaisedButton(
                child: Text('Proffessional'),
                onPressed: () {
                  level='Proffessional';
                  startGame();
                },
                splashColor: Colors.yellow,
              ),
            ],
          ),
        ));
  }

  void startGame() {
      Navigator.push(
      context, new MaterialPageRoute(
      builder: (context) => new SaperGame(level)));
  }

}

