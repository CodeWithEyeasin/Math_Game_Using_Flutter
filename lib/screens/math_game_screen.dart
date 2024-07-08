import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_game/utility/my_button.dart';

class MathGameScreen extends StatefulWidget {
  const MathGameScreen({super.key});

  @override
  State<MathGameScreen> createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> {
  // Number pad list
  List<String> numberPad = [
    '7', '8', '9', 'C',
    '4', '5', '6', 'DEL',
    '1', '2', '3', '=',
    '0', '-',
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
      operator = ['+', '-', '×', '÷'][randomNumber.nextInt(4)]; // Addition, subtraction, multiplication, division

      // Ensure division results in a positive integer
      if (operator == '÷' && numberA % numberB != 0) {
        int remainder = numberA % numberB;
        numberA += (numberB - remainder); // Adjust numberA to ensure integer division
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
        showResultDialog('Congratulations!\n You reached Level $currentLevel', true);
      } else {
        showResultDialog('Correct answer!', true);
      }
    } else {
      correctAnswersInRow = 0;
      showResultDialog('Wrong answer', false);
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
      case '÷':
        return numberA ~/ numberB;
      default:
        return 0;
    }
  }

  // Show result dialog
  void showResultDialog(String message, bool isCorrect) {
    int correctAnswer = calculateCorrectAnswer(); // Get the correct answer

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        elevation: 10,
        backgroundColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 80,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
              ),
              if (!isCorrect) // Show correct answer only if the answer is incorrect
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Correct answer: $correctAnswer',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 2
                ),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  if (isCorrect) {
                    goToNextQuestion();
                  } else {
                    goToNextQuestion(); // Optionally handle incorrect answer behavior here
                  }
                },
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  // Go to next question
  void goToNextQuestion() {
    setState(() {
      userAnswer = '';
    });
    generateQuestion();
  }

  // // Go back to question
  // void goBackToQuestion() {
  //   Navigator.pop(context);
  // }

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
