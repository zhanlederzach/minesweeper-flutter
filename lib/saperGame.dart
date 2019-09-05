import 'package:flutter/material.dart';
import 'board.dart';
import 'dart:async';

class Time{
  int hours;
  int minutes;
  int milliseconds;

  Time({this.hours=0, this.minutes=0, this.milliseconds=0});

  @override
  String toString(){
    String time="";
    if(hours!=0)  time+=hours.toString();
    if(minutes!=0)  time+=minutes.toString();
    time+=milliseconds.toString();

    return time;
  }

  void countTime(int millisecond){
  }

}

class SaperGame extends StatefulWidget {
  SaperGame(this.level) :  super();

  final String level;

  @override
  _SaperGameState createState() => _SaperGameState();
}

class _SaperGameState extends State<SaperGame> {
  
  Board myBoard;
  int squaresLeft;
  bool firstTap;

  Timer _timer;
  Time myTime = new Time();
  int _start = 0;

  void startTimer() {
    const oneMil = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneMil,
          (Timer timer) => setState(
            () {
            _start = _start + 1;
//            myTime.countTime(_start);
        },
      ),
    );
  }

  @override
    void initState() {
      super.initState();
      _initGame();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
//            color: Colors.pink,
            height: 60.0,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.transparent,
                child: Text('<-'),
                ),
                Text('${myBoard.bombCount}',
                    textAlign: TextAlign.center,
                    style: new TextStyle(color: Colors.black, fontSize: 25.0, )),
                InkWell(
                  onTap: () {
                    _initGame();
                  },
                  child: CircleAvatar(
                    child: Icon(
                      Icons.tag_faces,
                      color: Colors.black,
                      size: 40.0,
                    ),
                    backgroundColor: hexToColor("#F2CC8C"),
                  ),
                ),
                Text("$_start", textAlign: TextAlign.center,style: new TextStyle(color: Colors.black, fontSize: 25.0, )),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: (myBoard.rowCount * myBoard.columnCount),
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: myBoard.columnCount,
            ),
            itemBuilder: (context, position) {
              int rowNumber = (position / myBoard.columnCount).floor();
              int columnNumber = (position % myBoard.columnCount);
              
              Text text;
              Container container;
              Color backgroundColor = hexToColor("#F2CC8C");
              String digit;
              Square currentSquare = myBoard.board[rowNumber][columnNumber];
              if (currentSquare.isOpened == true) {
                if (currentSquare.hasBomb) {
                  digit = 'x';
                } else {
                  if(currentSquare.bombsAround==0){
                    digit = ' ';
                    backgroundColor = hexToColor("#F1E6C1");
                  }else{
                    digit = (currentSquare.bombsAround).toString();
                    backgroundColor = hexToColor("#F1E6C1");
                  }
                }
              }else{
                digit = ' ';
              }
              text = new Text(
                  digit,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  )
              );

              container = new Container(
                margin: EdgeInsets.all(0.5),
                decoration: new BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: text,
              );

              return InkWell(
                onTap: () {
                  if(squaresLeft==myBoard.columnCount*myBoard.rowCount){
                    setState(() {
                      startTimer();
                    });
                  }
                  if (currentSquare.hasBomb) {
                    setState(() {
                      myBoard.openAllBombs();
                      _handleGameOver();
                    });
                  }
                  if (currentSquare.bombsAround == 0) {
                    _handleTap(rowNumber, columnNumber);
                  } else {
                    setState(() {
                      myBoard.board[rowNumber][columnNumber].isOpened = true;
                      squaresLeft = squaresLeft - 1;
                    });
                  }
                  if(squaresLeft <= myBoard.bombCount) {
                    _handleWin();
                  }

                },
                splashColor: Colors.red,
                child: container
              );
            },
          )
        ],
      ),
    );
  }

  void _initGame(){
//    myBoard = new Board(30, 16, 99);
    int row = 0;
    int column = 0;
    int bombCount = 0;

    if(widget.level=='Easy') {
      row = 10;
      column = 10;
      bombCount = 10;
    }else if(widget.level=='Medium'){
      row = 20;
      column = 20;
      bombCount = 30;
    } else {
      row = 30;
      column = 16;
      bombCount = 99;
    }
    myBoard = new Board(row, column, bombCount);
    _start = 0;
    squaresLeft = myBoard.columnCount*myBoard.rowCount;
    setState(() {
      if(_timer!=null)  _timer.cancel();
    });
  }

  void _handleTap(int i, int j) {
      if(!myBoard.isInBoard(i, j) || myBoard.board[i][j].isOpened || myBoard.board[i][j].hasBomb)  return;

      myBoard.board[i][j].isOpened = true;
      squaresLeft = squaresLeft - 1;
      
      if(myBoard.board[i][j].bombsAround!=0) return;

//      for(int x=-1; x<2; ++x){
//        for(int y=-1; y<2; ++y){
//          if((x+y)!=0){
//            _handleTap(i+x, j+y);
//          }
//        }
//      }
       _handleTap(i-1, j+1);
       _handleTap(i-1, j);
       _handleTap(i-1, j-1);

       _handleTap(i, j-1);
       _handleTap(i, j+1);

       _handleTap(i+1, j+1);
       _handleTap(i+1, j);
       _handleTap(i+1, j-1);
    
    setState(() {});
  }

  void _handleWin() {
    _timer.cancel();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Congratulations! \nYour result is $_start seconds"),
          content: Text("You Win!"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _initGame();
                Navigator.pop(context);
              },
              child: Text("Play again"),
            ),
          ],
        );
      },
    );
  }

  Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void _handleGameOver() {
    if(_timer!=null)  _timer.cancel();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over!"),
          content: Text("You stepped on a mine! Chmownek"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _initGame();
                Navigator.pop(context);
              },
              child: Text("Play again"),
            ),
          ],
        );
      },
    );
  }


}