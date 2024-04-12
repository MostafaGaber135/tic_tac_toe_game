import 'package:flutter/material.dart';
import 'package:tic_tac_game/model/game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ...firstBlock(),
                  const SizedBox(
                    height: 50,
                  ),
                  _expanded(context),
                  ...lastBlock(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...firstBlock(),
                        ...lastBlock(),
                      ],
                    ),
                  ),
                  _expanded(context),
                ],
              ),
      ),
    );
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();
      if (!isSwitched && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(
      () {
        activePlayer = (activePlayer == 'X') ? 'O' : 'X';
        turn++;
        String winnerPlayer = game.checkWinner();
        if (winnerPlayer != '') {
          gameOver = true;
          result = '$winnerPlayer is the winner';
        } else if (!gameOver && turn == 9) {
          result = 'It\'s Draw!';
        }
      },
    );
  }

  List<Widget> firstBlock() {
    return [
      SwitchListTile.adaptive(
        title: const Text(
          'Turn on/off two player',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
        value: isSwitched,
        onChanged: (bool newValue) {
          setState(() {
            isSwitched = newValue;
          });
        },
      ),
      const SizedBox(
        height: 50,
      ),
      Text(
        'It\'s $activePlayer turn'.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 52,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> lastBlock() {
    return [
      const SizedBox(
        height: 20,
      ),
      Text(
        result,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 42,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 20,
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            activePlayer = 'X';
            gameOver = false;
            turn = 0;
            result = '';
          });
        },
        icon: const Icon(Icons.replay),
        label: const Text('Repeat the game'),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).splashColor),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ];
  }

  Expanded _expanded(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(25),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
        crossAxisCount: 3,
        children: List.generate(
          9,
          (index) => InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: gameOver ? null : () => _onTap(index),
            child: Container(
              decoration: BoxDecoration(
                color: _getSquareColor(index, context),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _getShadowColor(index, context),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  Player.playerX.contains(index)
                      ? 'X'
                      : Player.playerO.contains(index)
                          ? 'O'
                          : '',
                  style: TextStyle(
                    color: Player.playerX.contains(index)
                        ? Colors.blue
                        : Colors.pink,
                    fontSize: 52,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getSquareColor(int index, BuildContext context) {
    String winner = game.checkWinner();
    if (winner.isNotEmpty && gameOver) {
      List<List<int>> winCombinations = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
      ];

      for (var combination in winCombinations) {
        if (combination.contains(index)) {
          if ((winner == 'X' &&
                  combination.every((i) => Player.playerX.contains(i))) ||
              (winner == 'O' &&
                  combination.every((i) => Player.playerO.contains(i)))) {
            return Colors.yellowAccent.withOpacity(0.5);
          }
        }
      }
    }
    return Theme.of(context).shadowColor;
  }

  Color _getShadowColor(int index, BuildContext context) {
    String winner = game.checkWinner();
    if (winner.isNotEmpty && gameOver) {
      List<List<int>> winCombinations = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
      ];

      for (var combination in winCombinations) {
        if (combination.contains(index)) {
          if ((winner == 'X' &&
                  combination.every((i) => Player.playerX.contains(i))) ||
              (winner == 'O' &&
                  combination.every((i) => Player.playerO.contains(i)))) {
            return Colors.yellowAccent;
          }
        }
      }
    }
    return Colors.transparent;
  }
}
