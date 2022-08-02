import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class QuestionModel {
  late int id;
  late int year;
  late int number;
  late String question;
  late String image;
  late String optionA;
  late String optionB;
  late String optionC;
  late String optionD;
  late String answer;
  late String rationale;
  late String citations;
  late String subject;
  late String topic;

  QuestionModel({
    this.id = 0,
    this.year = 0,
    this.number = 0,
    this.question = "",
    this.image = "",
    this.optionA = "",
    this.optionB = "",
    this.optionC = "",
    this.optionD = "",
    this.answer = "",
    this.rationale = "",
    this.citations = "",
    this.subject = "",
    this.topic = "",
  });

  QuestionModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    id = json['id'];
    year = json['year'];
    number = json['number'];
    question = json['question'];
    image = json['image'];
    optionA = json['a'] is String ? json['a'] : json['a'].toString();
    optionB = json['b'] is String ? json['b'] : json['b'].toString();
    optionC = json['c'] is String ? json['c'] : json['c'].toString();
    optionD = json['d'] is String ? json['d'] : json['d'].toString();
    answer = json['answer'];
    rationale = json['rationale'];
    citations = json['citations'];
    subject = json['subject'];
    topic = json['topic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = Map<String, dynamic>();

    json['id'] = id;
    json['year'] = year;
    json['number'] = number;
    json['question'] = question;
    json['image'] = image;
    json['a'] = optionA;
    json['b'] = optionB;
    json['c'] = optionC;
    json['d'] = optionD;
    json['answer'] = answer;
    json['rationale'] = rationale;
    json['citations'] = citations;
    json['subject'] = subject;
    json['topic'] = topic;

    return json;
  }
}
