import 'dart:math';

class Player {
  static const x = 'X';
  static const o = 'O';
  static const empty = '';
  static List<int> playerX = [];
  static List<int> playerO = [];
}

extension ContainsAll on List {
  bool containsAll(int x, int y, [z]) {
    if (z == null) {
      return contains(x) && contains(y);
    } else {
      return contains(x) && contains(y) && contains(z);
    }
  }
}

class Game {
  void playGame(int index, String activePlayer) {
    if (activePlayer == 'X') {
      Player.playerX.add(index);
    } else {
      Player.playerO.add(index);
    }
  }

  String checkWinner() {
    String winner = '';
    if (Player.playerX.containsAll(0, 1, 2) ||
        Player.playerX.containsAll(3, 4, 5) ||
        Player.playerX.containsAll(6, 7, 8) ||
        Player.playerX.containsAll(0, 3, 6) ||
        Player.playerX.containsAll(1, 4, 7) ||
        Player.playerX.containsAll(2, 5, 8) ||
        Player.playerX.containsAll(0, 4, 8) ||
        Player.playerX.containsAll(2, 4, 6)) {
      winner = 'X';
    } else if (Player.playerO.containsAll(0, 1, 2) ||
        Player.playerO.containsAll(3, 4, 5) ||
        Player.playerO.containsAll(6, 7, 8) ||
        Player.playerO.containsAll(0, 3, 6) ||
        Player.playerO.containsAll(1, 4, 7) ||
        Player.playerO.containsAll(2, 5, 8) ||
        Player.playerO.containsAll(0, 4, 8) ||
        Player.playerO.containsAll(2, 4, 6)) {
      winner = 'O';
    } else {
      winner = '';
    }
    return winner;
  }

  Future<void> autoPlay(activePlayer) async {
    int index = 0;
    List<int> emptyCells = [];
    for (var i = 0; i < 9; i++) {
      if (!(Player.playerX.contains(i) || Player.playerO.contains(i))) {
        emptyCells.add(i);
      }
    }
    if (emptyCells.isEmpty) {
      return;
    }

    // Smart Moves
    String opponent = activePlayer == 'X' ? 'O' : 'X';
    index = findWinningMove(activePlayer, emptyCells);
    if (index == -1) {
      index = findWinningMove(opponent, emptyCells);
    }
    if (index == -1) {
      index = findCenter(emptyCells);
    }
    if (index == -1) {
      index = findRandom(emptyCells);
    }

    playGame(index, activePlayer);
  }

  int findWinningMove(String player, List<int> emptyCells) {
    List<List<int>> winCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], 
      [0, 3, 6], [1, 4, 7], [2, 5, 8], 
      [0, 4, 8], [2, 4, 6] 
    ];

    for (var combination in winCombinations) {
      int count = 0;
      int emptyIndex = -1;
      for (var index in combination) {
        if (Player.playerX.contains(index) && player == 'X') {
          count++;
        } else if (Player.playerO.contains(index) && player == 'O') {
          count++;
        } else {
          emptyIndex = index;
        }
      }
      if (count == 2 && emptyIndex != -1 && emptyCells.contains(emptyIndex)) {
        return emptyIndex;
      }
    }
    return -1;
  }

  int findCenter(List<int> emptyCells) {
    if (emptyCells.contains(4)) {
      return 4; 
    }
    return -1;
  }

  int findRandom(List<int> emptyCells) {
    Random random = Random();
    return emptyCells[random.nextInt(emptyCells.length)];
  }
}
