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

        // for(int x=-1; x<2; ++x){
        //   for(int y=-1; y<2; ++y){
        //     if((x+y)!=0){
        //       board[i][j].bombsAround+=_getBomb(i+x, j+y);
        //     }
        //   }
        // }

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

  bool isInBoard(int x, int y) =>
        x >= 0 && x < columnCount && y >= 0 && y < rowCount;

  int _getBomb(int x, int y) =>
    isInBoard(x, y) && board[x][y].hasBomb ? 1 : 0;  

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