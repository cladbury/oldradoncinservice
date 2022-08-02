import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:radoncinservice/constants/color_constant.dart';
import 'package:radoncinservice/models/question_model.dart';
import 'package:radoncinservice/models/user_model.dart';
import 'package:radoncinservice/widgets/test_question.dart';
import "dart:math";
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

//import 'package:oncpatient/widgets/web_appbar.dart';

class WebHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WebHomePageState();
}

class WebHomePageState extends State<WebHomePage> {
  List<QuestionModel> _futureQuestions = [];
  List<QuestionModel> _questionSubset = [];
  int nQuestions = 1;
  int qIndex = 0;
  Set<String> subjects = Set();
  String qFilter = "all";

  Future<void> getQuestions([bool ignoreLocal = false]) async {
    final String response = kIsWeb
        ? await rootBundle.loadString('data/TXIT.json')
        : await rootBundle.loadString('assets/data/TXIT.json');
    final data = await json.decode(response);
    setState(() {
      _futureQuestions = data.map<QuestionModel>((json) {
        subjects.add(json['subject']);
        return QuestionModel.fromJson(json: json);
      }).toList();
      _futureQuestions.sort((a, b) {
        return a.number.compareTo(b.number);
      });
    });
  }

  Future<void> _showFilterDialog(context, userData) async {
    ThemeData theme = Theme.of(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => FilterDialog(updateFilters, subjects, userData),
    );
  }

  Future<void> _showStatsDialog(context, userData, questions) async {
    ThemeData theme = Theme.of(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatsDialog(userData, questions),
    );
  }

  updateFilters(filters, userData) {
    RangeValues yearRange = filters['filter_year_range'];
    List<String> subjectsToInclude = filters['filter_subjects'];
    int minYear = yearRange.start.round();
    int maxYear = yearRange.end.round();
    setState(() {
      _questionSubset = _futureQuestions
          .where((q) =>
              subjectsToInclude.contains(q.subject) &&
              q.year >= minYear &&
              q.year <= maxYear)
          .toList();
      qFilter = filters['filter_questions_included'];
      updateSubset(userData);
      nQuestions = _questionSubset.length;
      qIndex = nQuestions == 0 ? 0 : Random().nextInt(nQuestions);
    });
  }

  @override
  void updateSubset(UserEntity user) {
    Set<int> answered =
        [...user.correctAnswers, ...user.incorrectAnswers].toSet();
    setState(() {
      if (qFilter == "unanswered") {
        _questionSubset =
            _questionSubset.where((q) => !answered.contains(q.id)).toList();
      } else if (qFilter == "incorrect") {
        _questionSubset = _questionSubset
            .where((q) =>
                user.incorrectAnswers.contains(q.id) &&
                !user.correctAnswers.contains(q.id))
            .toList();
      } else if (qFilter == "marked") {
        _questionSubset =
            _questionSubset.where((q) => user.marked.contains(q.id)).toList();
      }
      nQuestions = _questionSubset.length;
      qIndex = nQuestions == 0 ? 0 : Random().nextInt(nQuestions);
    });
  }

  @override
  void initState() {
    super.initState();
    getQuestions(true).then((value) {
      _questionSubset = _futureQuestions;
      nQuestions = _questionSubset.length;
      qIndex = nQuestions == 0 ? 0 : Random().nextInt(nQuestions);
    });
  }

  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserEntity>(context);
    //updateSubset(userData);
    final theme = Theme.of(context);
    List<QuestionModel> qbank = _questionSubset;
    return Scaffold(
      appBar: AppBar(
        title: Text('Rad Onc In-Service (TXIT) Tester'),
        backgroundColor: colorAppBar,
        actions: [
          /* TextButton(
              onPressed: () {
                setState(() {
                  qIndex = Random().nextInt(nQuestions);
                });
              },
              child: Text("Next Question",
                  style:
                      theme.textTheme.button?.copyWith(color: Colors.white))), */
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              _showFilterDialog(context, userData);
            },
          ),
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              _showStatsDialog(context, userData, _futureQuestions);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Text(
          "${nQuestions} Questions Included Under Current Filters",
          textAlign: TextAlign.center,
          style: theme.textTheme.headline2,
        ),
      ),
      body: SafeArea(
          child: _questionSubset.length > 0
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      TestQuestion(
                        qbank[qIndex],
                        key: ValueKey(qbank[qIndex].id),
                      ),
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(colorAppBar)),
                          onPressed: () {
                            setState(() {
                              updateSubset(userData);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Next Question",
                                style: theme.textTheme.button
                                    ?.copyWith(color: colorWhite)),
                          )),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator())),
    );
  }
}

class FilterDialog extends StatefulWidget {
  final Function notifyParent;
  final Set<String> subjects;
  final UserEntity userdata;

  FilterDialog(this.notifyParent, this.subjects, this.userdata);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  late List<String> subjects;
  late List<String> initsubjects;

  @override
  void initState() {
    super.initState();
    subjects = widget.subjects.toList();
    subjects.sort();
    initsubjects = subjects;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SimpleDialog(
      //title: Text("Filter", style: theme.textTheme.headline2),
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    FormBuilderDropdown(
                      name: 'filter_questions_included',
                      decoration: InputDecoration(
                        labelText: 'Select Questions to Include',
                      ),
                      initialValue: 'all',
                      items: [
                        DropdownMenuItem(
                          value: 'unanswered',
                          child: Text('Unanswered Questions'),
                        ),
                        DropdownMenuItem(
                          value: 'incorrect',
                          child: Text('Incorrect Questions'),
                        ),
                        DropdownMenuItem(
                          value: 'marked',
                          child: Text('Marked Questions'),
                        ),
                        DropdownMenuItem(
                          value: 'all',
                          child: Text('All Questions'),
                        ),
                      ],
                    ),
                    FormBuilderRangeSlider(
                        decoration: InputDecoration(
                          labelText: 'Select Year Range',
                        ),
                        initialValue: RangeValues(2012, 2021),
                        numberFormat: NumberFormat("####"),
                        name: 'filter_year_range',
                        min: 2012,
                        max: 2021),
                    FormBuilderCheckboxGroup(
                      name: 'filter_subjects',
                      decoration: InputDecoration(
                        labelText: 'Select Subjects',
                      ),
                      initialValue: initsubjects,
                      orientation: OptionsOrientation.vertical,
                      options: subjects.map((s) {
                        return FormBuilderFieldOption(
                          value: s,
                          child: Text(s),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _formKey.currentState?.save();
                        if (_formKey.currentState!.validate()) {
                          widget.notifyParent(
                              _formKey.currentState?.value, widget.userdata);
                          Navigator.pop(context, true);
                        } else {
                          print("validation failed");
                        }
                      },
                    ),
                  ),
                  /* SizedBox(width: 20),
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        "Clear",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          initsubjects = [];
                        });
                      },
                    ),
                  ), */
                  SizedBox(width: 20),
                  Expanded(
                    child: MaterialButton(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        "Reset",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class StatsDialog extends StatefulWidget {
  UserEntity userData;
  List<QuestionModel> questions;
  StatsDialog(this.userData, this.questions);

  @override
  _StatsDialogState createState() => _StatsDialogState();
}

class _StatsDialogState extends State<StatsDialog> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    int nAnswered = widget.userData.correctAnswers.length +
        widget.userData.incorrectAnswers.length;
    int uniqueAnswered = [
      ...widget.userData.correctAnswers,
      ...widget.userData.incorrectAnswers
    ].toSet().length;
    int uniqueCorrect = [...widget.userData.correctAnswers].toSet().length;
    return SimpleDialog(
      title: Text("Statistics", style: theme.textTheme.headline2),
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text("Unique Questions Answered: ${uniqueAnswered}"),
              Text("Unique Questions Correct: ${uniqueCorrect}"),
              Text("Total Questions Answered: ${nAnswered}"),
              Text(
                  "Total Questions Correct: ${widget.userData.correctAnswers.length}"),
              Text(
                  "Unanswered Questions: ${widget.questions.length - nAnswered}"),
              Text("Marked Questions: ${widget.userData.marked.length}"),
            ],
          ),
        )
      ],
    );
  }
}
