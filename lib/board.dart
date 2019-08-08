import 'dart:math';

class Board{

  int rowCount;
  int columnCount;
  List<List<Square>> board;
  int bombCount;

  Board(this.rowCount, this.columnCount, this.bombCount){
    initBoard();
  }

  initBoard(){

    board = List.generate(rowCount, (i) {
      return List.generate(columnCount, (j) {
        return Square();
      });
    });

    Random randomizer = new Random();
    List<int> bombsId = List<int>();

    for(int i = 0; i<bombCount; ++i){
      int randNumber = randomizer.nextInt(columnCount*rowCount);
      while(!bombsId.contains(randNumber)){
        bombsId.add(randNumber);
        board[(randNumber/columnCount).floor()][randNumber%columnCount].hasBomb=true;
      }
    }

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {

        board[i][j].bombsAround+=_getBomb(i-1, j-1);
        board[i][j].bombsAround+=_getBomb(i-1, j);
        board[i][j].bombsAround+=_getBomb(i-1, j+1);

        board[i][j].bombsAround+=_getBomb(i, j-1);
        board[i][j].bombsAround+=_getBomb(i, j+1);

        board[i][j].bombsAround+=_getBomb(i+1, j-1);
        board[i][j].bombsAround+=_getBomb(i+1, j);
        board[i][j].bombsAround+=_getBomb(i+1, j+1);
        
      }
    }

  }

  bool isInBoard(int x, int y)  {
    return x >= 0 && x < rowCount && y >= 0 && y < columnCount;
  }


  int _getBomb(int x, int y) {
    if(isInBoard(x, y)) return board[x][y].hasBomb ? 1 : 0;
    else return 0;
  }


  void openAllBombs(){
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if(board[i][j].hasBomb) {
          board[i][j].isOpened = true;
        }
      }
    }
  }

}

class Square{
  bool hasBomb;
  bool isOpened;
  int bombsAround;

  Square({this.hasBomb=false, this.isOpened = false, this.bombsAround=0});

}