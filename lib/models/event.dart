import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String category;
  final DateTime date;
  final String priority;
  final bool status;

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.priority,
    required this.status,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Event(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      priority: data['priority'] ?? '',
      status: data['status'] ?? false,
    );
  }

  @override
  String toString() => title;
}
