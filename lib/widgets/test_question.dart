import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radoncinservice/constants/color_constant.dart';
import 'package:radoncinservice/models/question_model.dart';
import 'package:radoncinservice/models/user_model.dart';

class TestQuestion extends StatefulWidget {
  QuestionModel question;
  TestQuestion(this.question, {Key? key}) : super(key: key);

  @override
  _TestQuestionState createState() => _TestQuestionState();
}

class _TestQuestionState extends State<TestQuestion> {
  var _showAnswer = false;
  var _answered = false;
  var marked = false;
  var colorA = colorSplash;
  var colorB = colorSplash;
  var colorC = colorSplash;
  var colorD = colorSplash;

  Widget _buildAnswerTile(String text, ThemeData theme, String selectedAnswer,
      QuestionModel question, Color color, UserEntity userData) {
    String correctAnswer = question.answer;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
            color: color,
            border: Border.all(color: colorBorder),
            borderRadius: BorderRadius.circular(10)),
        child: InkWell(
            child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(text, style: theme.textTheme.headline2),
                )),
            onTap: () {
              setState(() {
                _showAnswer = true;
                if (!_answered) {
                  if (correctAnswer.contains(selectedAnswer)) {
                    userData.addCorrectAnswer(question.id);
                  } else {
                    userData.addIncorrectAnswer(question.id);
                  }
                  if (selectedAnswer.contains("A")) {
                    colorA = colorLightRed;
                  } else if (selectedAnswer.contains("B")) {
                    colorB = colorLightRed;
                  } else if (selectedAnswer.contains("C")) {
                    colorC = colorLightRed;
                  } else if (selectedAnswer.contains("D")) {
                    colorD = colorLightRed;
                  }
                  if (correctAnswer.contains("A")) {
                    colorA = colorLightGreen;
                  } else if (correctAnswer.contains("B")) {
                    colorB = colorLightGreen;
                  } else if (correctAnswer.contains("C")) {
                    colorC = colorLightGreen;
                  } else if (correctAnswer.contains("D")) {
                    colorD = colorLightGreen;
                  }
                }
                _answered = true;
              });
            }),
      ),
    );
  }

  updateMarked(UserEntity userData, QuestionModel question) {
    setState(() {
      if (userData.marked.contains(question.id)) {
        marked = true;
      } else {
        marked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserEntity>(context);
    ThemeData theme = Theme.of(context);
    final testQuestion = widget.question;
    updateMarked(userData, testQuestion);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Text(
          "Year: ${testQuestion.year}, Question: ${testQuestion.number}, Subject: ${testQuestion.subject}, Topic: ${testQuestion.topic}",
          style: theme.textTheme.headline2,
          textAlign: TextAlign.center,
        ),
        Divider(),
        Text(testQuestion.question, style: theme.textTheme.headline1),
        if (testQuestion.image != "")
          Image.network(
            "https://cladbury.github.io/radoncinservicefiles/${testQuestion.image}",
          ),
        Divider(),
        _buildAnswerTile("A. ${testQuestion.optionA}", theme, "A", testQuestion,
            colorA, userData),
        _buildAnswerTile("B. ${testQuestion.optionB}", theme, "B", testQuestion,
            colorB, userData),
        _buildAnswerTile("C. ${testQuestion.optionC}", theme, "C", testQuestion,
            colorC, userData),
        _buildAnswerTile("D. ${testQuestion.optionD}", theme, "D", testQuestion,
            colorD, userData),
        if (_showAnswer)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              Text("Answer: ${testQuestion.answer}",
                  style: theme.textTheme.headline2),
              Divider(),
              Text("Rationale: ${testQuestion.rationale}",
                  style: theme.textTheme.headline2),
              if (testQuestion.citations != "") Divider(),
              if (testQuestion.citations != "")
                Text(
                  "Citation: ${testQuestion.citations}",
                  style: theme.textTheme.headline2,
                ),
            ],
          ),
        SizedBox(height: 10),
        TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colorAppBar)),
            onPressed: () {
              setState(() {
                marked = !marked;
                userData.toggleMarked(testQuestion.id);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(marked ? "Unmark Question" : "Mark Question",
                  style: theme.textTheme.button?.copyWith(color: colorWhite)),
            )),
      ]),
    );
  }
}
