import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const backgroundColor = Color.fromARGB(255, 233, 236, 238);
const iconColor = Color.fromARGB(255, 133, 172, 183);
const containerColor = Colors.white;
const subtitleColor = Colors.grey;
const highTaskContainerColor = Color.fromARGB(255, 255, 105, 97);
const mediumTaskContainerColor = Color.fromARGB(255, 253, 253, 150);
const lowTaskContainerColor = Color.fromARGB(255, 119, 221, 119);
const barColor = Color.fromARGB(255, 252, 108, 0);

final firestore = FirebaseFirestore.instance;
final CollectionReference collectionReference = firestore.collection('tasks');

Widget sizedBoxHeight(double height) {
  return SizedBox(
    height: height,
  );
}

Widget sizedBoxWidth(double width) {
  return SizedBox(
    width: width,
  );
}

const inProgressIcon = Icon(
  Icons.incomplete_circle,
  color: Colors.purple,
  size: 35,
);

const completedIcon = Icon(
  Icons.check_circle_rounded,
  color: Colors.blue,
  size: 35,
);

const canceledIcon = Icon(
  Icons.cancel,
  color: Colors.red,
  size: 35,
);

Map<String, Color> categoryTextColors = {
  'FINANCE': Colors.green.shade800,
  'WORK': Colors.blue,
  'ENTERTAINMENT': Colors.pink,
  'PERSONAL': Colors.red,
  'HEALTH': Colors.yellow,
};
