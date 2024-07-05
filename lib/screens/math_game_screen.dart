import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_game/screens/score_history_screen.dart';

class MathGameScreen extends StatefulWidget {
  const MathGameScreen({super.key, required this.playerName});
  final String playerName;

  @override
  State<MathGameScreen> createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> {
  List<String> numberPad = [
    '7',
    '8',
    '9',
    'C',
    '4',
    '5',
    '6',
    'DEL',
    '1',
    '2',
    '3',
    '=',
    '0',
    '.',
    '-',
    'NEW',
  ];
  late final VoidCallback onTap;
  var buttonColor = const Color(0xFF323D6B);
  final Random _random = Random();
  late int _num1;
  late int _num2;
  late num correctAnswer;
  late String _operator;
  late String _question;
  String _userAnswer = '';

  int _score = 0;

  final Color _questionColor = const Color(0xFF323D5B);
  final List<Map<String, dynamic>> _scoreHistory = [];
  String _currentDifficulty = 'Easy';

  @override
  void initState() {
    super.initState();
    _generateQuestion(); // Initialize the question
  }

  void _generateQuestion() {
    int maxNumber;
    switch (_currentDifficulty) {
      case 'Hard':
        maxNumber = 1000;
        break;
      case 'Medium':
        maxNumber = 100;
        break;
      default:
        maxNumber = 10;
    }
    setState(() {
      _num1 = _random.nextInt(maxNumber);
      _num2 = _random.nextInt(maxNumber);
      _operator = ['+', '-', '*', '/'][_random.nextInt(4)];
      if (_operator == '/' && _num2 == 0) {
        _num2 = 1;
      }
      _question = '$_num1 $_operator $_num2 = ';
      _userAnswer = '';
    });
  }

  void _checkAnswer() {
    switch (_operator) {
      case '+':
        correctAnswer = _num1 + _num2;
        break;
      case '-':
        correctAnswer = _num1 - _num2;
        break;
      case '*':
        correctAnswer = _num1 * _num2;
        break;
      case '/':
        correctAnswer = _num1 / _num2;
        break;
    }
    setState(() {
      if (_isAnswerCorrect(double.tryParse(_userAnswer))) {
        _score++;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF323D5B),
              content: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Correct!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _generateQuestion();
                        Navigator.of(context).pop();
                        setState(() {
                          _userAnswer = '';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF323D5B),
              content: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Sorry, try again!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _userAnswer = '';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.rotate_left,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    });
  }

  bool _isAnswerCorrect(num? userAnswer) {
    if (userAnswer == null) return false;
    return (userAnswer - correctAnswer).abs() < 0.0001;
  }

  void _endGame() {
    setState(() {
      _scoreHistory.add({
        'playerName': widget.playerName,
        'score': _score,
        'date': DateTime.now().toString(),
      });
      _score = 0;
      _generateQuestion();
    });
  }

  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        _checkAnswer();
      } else if (button == 'NEW') {
        _userAnswer = '';
        _generateQuestion();
        if (correctAnswer <= 0) {
          _score;
        } else if (correctAnswer > 0) {
          if (_score > 0) {
            _score--;
          }
        }
      } else if (button == 'C') {
        _userAnswer = '';
      } else if (button == 'DEL') {
        if (_userAnswer.isNotEmpty) {
          _userAnswer = _userAnswer.substring(0, _userAnswer.length - 1);
        }
      } else if (_userAnswer.length < 7) {
        _userAnswer = _userAnswer + button;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF323D5B),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 70,
            color: const Color(0xFF323D6B),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.playerName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 130),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScoreHistoryScreen(scoreHistory: _scoreHistory),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history_sharp, color: Colors.white, size: 30),
                ),
                PopupMenuButton<String>(
                  color: const Color(0xFF323D5B),
                  onSelected: (value) {
                    setState(() {
                      _currentDifficulty = value;
                    });
                    _generateQuestion();
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Easy', 'Medium', 'Hard'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(
                          choice,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  child: const Icon(Icons.menu, color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Score: $_score',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _questionColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _question,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 125,
                      decoration: BoxDecoration(
                        color: const Color(0xFF323D6B),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          _userAnswer,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: numberPad.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: GestureDetector(
                    onTap: () {
                      buttonTapped(numberPad[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          numberPad[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                    child: const Text(
                      'Start Again',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _endGame();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                    child: const Text(
                      'End Game',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
