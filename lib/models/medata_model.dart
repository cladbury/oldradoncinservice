import 'package:cloud_firestore/cloud_firestore.dart';

class Metadata {
  late DateTime? createdDate;
  late DateTime? modifiedDate;

  Metadata({
    this.createdDate,
    this.modifiedDate,
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    createdDate = (json['createdDate'] as Timestamp).toDate();
    modifiedDate = (json['modifiedDate'] as Timestamp).toDate();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdDate'] =
        Timestamp.fromDate(this.createdDate ?? DateTime.now());
    data['modifiedDate'] =
        Timestamp.fromDate(this.modifiedDate ?? DateTime.now());

    data.removeWhere((key, value) => value == null);
    return data;
  }

  Metadata.now() {
    createdDate = DateTime.now();
    modifiedDate = DateTime.now();
  }
}

Timestamp getTimestamp() => Timestamp.fromDate(DateTime.now());
