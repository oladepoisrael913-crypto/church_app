import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final Timestamp date;
  final String location;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
  });

  factory Event.fromMap(String id, Map<String, dynamic> data) {
    return Event(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? Timestamp.now(),
      location: data['location'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'location': location,
    };
  }
}