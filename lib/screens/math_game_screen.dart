import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_game/utility/message_result.dart';
import 'package:math_game/utility/my_button.dart';

class MathGameScreen extends StatefulWidget {
  const MathGameScreen({Key? key}) : super(key: key);

  @override
  State<MathGameScreen> createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> {
  // Number pad list
  List<String> numberPad = [
    '7', '8', '9', 'C',
    '4', '5', '6', 'DEL',
    '1', '2', '3', '=',
    '0',
  ];

  // Initial values
  int numberA = 1;
  int numberB = 1;
  String operator = '+';
  String userAnswer = '';
  int correctAnswersInRow = 0;
  int currentLevel = 1;

  // Random number generator
  var randomNumber = Random();

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  // Generate a new question
  void generateQuestion() {
    setState(() {
      numberA = randomNumber.nextInt(10 * currentLevel) + 1;
      numberB = randomNumber.nextInt(10 * currentLevel) + 1;
      operator = ['+', '×'][randomNumber.nextInt(2)]; // Only addition and multiplication for positive results

      // Ensure division results in a positive integer
      if (operator == '*' || (operator == '+' && numberA > numberB)) {
        // No need to adjust for multiplication or addition with larger number
      } else {
        numberA = max(numberA, numberB);
      }
    });
  }

  // Handle button taps
  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        checkResult();
      } else if (button == 'C') {
        userAnswer = '';
      } else if (button == 'DEL') {
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      } else if (userAnswer.length < 3) {
        userAnswer += button;
      }
    });
  }

  // Check user's answer
  void checkResult() {
    int correctAnswer = calculateCorrectAnswer();

    if (correctAnswer == int.parse(userAnswer)) {
      correctAnswersInRow++;
      if (correctAnswersInRow == 5) {
        currentLevel++;
        correctAnswersInRow = 0;
        showResultDialog('Congratulations! You reached Level\n $currentLevel', Icons.arrow_forward, goToNextQuestion);
      } else {
        showResultDialog('Correct!', Icons.arrow_forward, goToNextQuestion);
      }
    } else {
      correctAnswersInRow = 0;
      showResultDialog('Sorry, try again', Icons.rotate_left, goBackToQuestion);
    }
  }

  // Calculate correct answer based on current question
  int calculateCorrectAnswer() {
    switch (operator) {
      case '+':
        return numberA + numberB;
      case '-':
        return numberA - numberB;
      case '×':
        return numberA * numberB;
      case '/':
        return numberA ~/ numberB;
      default:
        return 0;
    }
  }

  // Show result dialog
  void showResultDialog(String message, IconData icon, Function() onTap) {
    showDialog(
      context: context,
      builder: (context) => ResultMessage(
        message: message,
        onTap: onTap,
        icon: icon,
      ),
    );
  }

  // Go to next question
  void goToNextQuestion() {
    Navigator.of(context).pop();
    setState(() {
      userAnswer = '';
    });
    generateQuestion();
  }

  // Go back to question
  void goBackToQuestion() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      body: Column(
        children: [
          // Level display
          Container(
            height: 60,
            color: Colors.deepPurple,
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    'Level $currentLevel',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Level progress indicator
          Container(
            height: 100,
            color: Colors.deepPurple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: index < correctAnswersInRow ? Colors.green : Colors.deepPurple.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: index < correctAnswersInRow ? const Icon(Icons.check, color: Colors.white, size: 50) : null,
                );
              }),
            ),
          ),

          // Question display
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Question text
                Text(
                  '$numberA $operator $numberB = ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Answer box
                Container(
                  height: 70,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      userAnswer,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Number pad
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GridView.builder(
                itemCount: numberPad.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) {
                  return MyButton(
                    child: numberPad[index],
                    onTap: () => buttonTapped(numberPad[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
