import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'medata_model.dart';

class UserEntity with ChangeNotifier {
  String? userId;
  List<int> correctAnswers;
  List<int> incorrectAnswers;
  List<int> marked;
  Metadata? metadata;

  UserEntity({
    this.userId,
    this.correctAnswers = const <int>[],
    this.incorrectAnswers = const <int>[],
    this.marked = const <int>[],
    this.metadata,
  });

  UserEntity.fromJson({
    DocumentSnapshot<Map<String, dynamic>>? snapshot,
  })  : correctAnswers = <int>[],
        incorrectAnswers = <int>[],
        marked = <int>[] {
    if (snapshot == null) return;
    if (snapshot.data() == null) return;
    Map<String, dynamic> json = Map<String, dynamic>.from(snapshot.data()!);
    json['userId'] = snapshot.id;
    userId = json['userId'];
    correctAnswers = json['correctAnswers'].cast<int>();
    incorrectAnswers = json['incorrectAnswers'].cast<int>();
    marked = json['marked'] != null ? json['marked'].cast<int>() : <int>[];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = userId;
    data['correctAnswers'] = correctAnswers;
    data['incorrectAnswers'] = incorrectAnswers;
    data['marked'] = marked;
    data['metadata'] = metadata?.toJson();
    data.removeWhere((key, value) => value == null);
    return data;
  }

  Stream<UserEntity> streamUser(String id) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .snapshots()
        .map((snapshot) {
      final currentUser = UserEntity.fromJson(snapshot: snapshot);
      return currentUser;
    }).handleError((err) {
      print(err);
      return UserEntity(userId: id, correctAnswers: [], incorrectAnswers: []);
    });
  }

  Future<void> addToFirestore() async {
    Map<String, dynamic> json = this.toJson();
    json["metadata"] = Metadata.now().toJson();
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(this.userId)
        .set(json);
  }

  Future<DocumentReference> updateInFirestore() async {
    Map<String, dynamic> json = this.toJson();
    if (metadata != null) json["metadata"]["modifiedDate"] = getTimestamp();
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(this.userId)
        .update(json)
        .then(
      (_) {
        return FirebaseFirestore.instance.collection("users").doc(this.userId);
      },
    );
  }

  void addCorrectAnswer(int id) {
    var qList = [...correctAnswers];
    qList.add(id);
    correctAnswers = qList;
    updateInFirestore();
    notifyListeners();
  }

  void addIncorrectAnswer(int id) {
    var qList = [...incorrectAnswers];
    qList.add(id);
    incorrectAnswers = qList;
    updateInFirestore();
    notifyListeners();
  }

  void toggleMarked(int id) {
    var qList = [...marked];
    if (qList.contains(id)) {
      qList.remove(id);
    } else {
      qList.add(id);
    }
    marked = qList;
    updateInFirestore();
    notifyListeners();
  }
}

String generateRandomString(int len) {
  Random r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
