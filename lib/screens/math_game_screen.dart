import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_game/const.dart';
import 'package:math_game/utility/message_result.dart';
import 'package:math_game/utility/my_button.dart';

class MathGameScreen extends StatefulWidget {
  const MathGameScreen({Key? key}) : super(key: key);

  @override
  State<MathGameScreen> createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> {
  // number pad list
  List<String> numberPad = [
    '7', '8', '9', 'C',
    '4', '5', '6', 'DEL',
    '1', '2', '3', '=',
    '0',
  ];

  // number A, number B, operator
  int numberA = 1;
  int numberB = 1;
  String operator = '+';

  // user answer
  String userAnswer = '';

  // user tapped a button
  void buttonTapped(String button) {
    setState(() {
      if (button == '=') {
        // calculate if user is correct or incorrect
        checkResult();
      } else if (button == 'C') {
        // clear the input
        userAnswer = '';
      } else if (button == 'DEL') {
        // delete the last number
        if (userAnswer.isNotEmpty) {
          userAnswer = userAnswer.substring(0, userAnswer.length - 1);
        }
      } else if (userAnswer.length < 3) {
        // maximum of 3 numbers can be inputted
        userAnswer += button;
      }
    });
  }

  // check if user is correct or not
  void checkResult() {
    int correctAnswer;
    switch (operator) {
      case '+':
        correctAnswer = numberA + numberB;
        break;
      case '-':
        correctAnswer = numberA - numberB;
        break;
      case '*':
        correctAnswer = numberA * numberB;
        break;
      case '/':
        correctAnswer = numberA ~/ numberB; // Integer division
        break;
      default:
        correctAnswer = 0;
    }

    if (correctAnswer == int.parse(userAnswer)) {
      showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: 'Correct!',
            onTap: goToNextQuestion,
            icon: Icons.arrow_forward,
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return ResultMessage(
            message: 'Sorry, try again',
            onTap: goBackToQuestion,
            icon: Icons.rotate_left,
          );
        },
      );
    }
  }

  // create random numbers and operator
  var randomNumber = Random();

  // GO TO NEXT QUESTION
  void goToNextQuestion() {
    // dismiss alert dialog
    Navigator.of(context).pop();

    // reset values
    setState(() {
      userAnswer = '';
    });

    // create a new question
    numberA = randomNumber.nextInt(10) + 1; // Avoid zero for division
    numberB = randomNumber.nextInt(10) + 1; // Avoid zero for division

    // random operator
    List<String> operators = ['+', '-', '*', '/'];
    operator = operators[randomNumber.nextInt(operators.length)];

    // Ensure the division results in an integer
    if (operator == '/') {
      numberA = (numberA ~/ numberB) * numberB; // Make sure numberA is divisible by numberB
    }
  }

  // GO BACK TO QUESTION
  void goBackToQuestion() {
    // dismiss alert dialog
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      body: Column(
        children: [
          // level progress, player needs 5 correct answers in a row to proceed to next level
          Container(
            height: 160,
            color: Colors.deepPurple,
          ),

          // question
          Expanded(
            child: Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // question
                    Text(
                      '$numberA $operator $numberB = ',
                      style: whiteTextStyle,
                    ),

                    // answer box
                    Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          userAnswer,
                          style: whiteTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // number pad
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
