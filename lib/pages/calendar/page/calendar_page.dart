import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_planner/constants/constants.dart';
import 'package:task_planner/models/event.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<Event>> _events = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: barColor,
        title: const Text('Calendar'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          _events = {};
          for (var doc in snapshot.data!.docs) {
            Event event = Event.fromFirestore(doc);
            DateTime eventDate = DateTime(
              event.date.year,
              event.date.month,
              event.date.day,
            );

            if (_events[eventDate] == null) {
              _events[eventDate] = [];
            }
            _events[eventDate]!.add(event);
          }

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle:
                      Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: barColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: barColor,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: const TextStyle(
                    color: barColor,
                  ),
                ),
                focusedDay: _focusedDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                eventLoader: (day) {
                  DateTime eventDate = DateTime(
                    day.year,
                    day.month,
                    day.day,
                  );
                  return _events[eventDate] ?? [];
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        right: 1,
                        bottom: 1,
                        child: _buildMarkers(events),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              _buildEventList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMarkers(List events) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: events.map((event) {
        return Container(
          width: 5.0,
          height: 5.0,
          margin: const EdgeInsets.symmetric(horizontal: 0.5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEventList() {
    if (_selectedDay == null) {
      return Container();
    }

    final events = _events[_selectedDay] ?? [];

    return SizedBox(
      height: 300,
      child: ListView(
        children: events
            .map((event) => ListTile(
                  title: Text(event.toString()),
                ))
            .toList(),
      ),
    );
  }
}
