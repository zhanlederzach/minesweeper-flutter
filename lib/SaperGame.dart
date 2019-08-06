import 'package:flutter/material.dart';
import 'board.dart';

class SaperGame extends StatefulWidget {
  @override
  _SaperGameState createState() => _SaperGameState();
}

class _SaperGameState extends State<SaperGame> {
  
  Board myBoard;
  int squaresLeft;

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
            color: Colors.pink,
            height: 60.0,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                    backgroundColor: Colors.yellowAccent,
                  ),
                )
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: myBoard.columnCount,
            ),
            itemBuilder: (context, position) {
              // Get row and column number of square
              int rowNumber = (position / myBoard.columnCount).floor();
              int columnNumber = (position % myBoard.columnCount);
              
              Text text;

              if  (myBoard.board[rowNumber][columnNumber].isOpened == true) {
                if (myBoard.board[rowNumber][columnNumber].hasBomb) {
                  text = new Text('x', textAlign: TextAlign.center,style: new TextStyle(color: hexToColor("#F2A03D"), fontSize: 25.0, ));
                } else {
                  text = new Text((myBoard.board[rowNumber][columnNumber].bombsAround).toString(),textAlign: TextAlign.center, style: new TextStyle(color: hexToColor("#F2A03D"), fontSize: 25.0));
                }
              }else{
                text = new Text('-',textAlign: TextAlign.center, style: new TextStyle(color: hexToColor("#F2A03D"), fontSize: 25.0));
              }

              return InkWell(
                // Opens square
                onTap: () {
                  if (myBoard.board[rowNumber][columnNumber].hasBomb) {
                    setState(() {
                      myBoard.openAllBombs();  
                      _handleGameOver();
                    });
                  }
                  if (myBoard.board[rowNumber][columnNumber].bombsAround == 0) {
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
                child: Container(
                  color: Colors.green,
                  child: text,
                ),
              );
            },
            itemCount: (myBoard.rowCount * myBoard.columnCount),
          )
        ],
      ),
    );
  }

  void _initGame(){
    myBoard = new Board(10, 10, 10);
    squaresLeft=myBoard.columnCount*myBoard.rowCount;
    setState(() {});
  }

  void _handleTap(int i, int j) {
      if(!myBoard.isInBoard(i, j) || myBoard.board[i][j].isOpened || myBoard.board[i][j].hasBomb)  return;

      myBoard.board[i][j].isOpened = true;
      squaresLeft = squaresLeft - 1;
      
      if(myBoard.board[i][j].bombsAround!=0) return;
      print('i is $i');
      print('j is $j');

      for(int x=-1; x<2; ++x){
        for(int y=-1; y<2; ++y){
          if((x+y)!=0){
            _handleTap(i+x, j+y);    
          }
        }
      }
      // _handleTap(i-1, j+1);
      // _handleTap(i-1, j);
      // _handleTap(i-1, j-1);

      // _handleTap(i, j-1);
      // _handleTap(i, j+1);

      // _handleTap(i+1, j+1);
      // _handleTap(i+1, j);
      // _handleTap(i+1, j-1);      
    
    setState(() {});
  }

  void _handleWin() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Congratulations!"),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over!"),
          content: Text("You stepped on a mine!"),
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