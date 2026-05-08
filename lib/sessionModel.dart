import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  final String docId;
  final String name;
  final DateTime date;

  Session({
    required this.docId,
    required this.name,
    required this.date,
  });

  factory Session.fromMap(String id, Map<String, dynamic> data) {
    return Session(
      docId: id,
      name: data['name'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': Timestamp.fromDate(date),
    };
  }
}