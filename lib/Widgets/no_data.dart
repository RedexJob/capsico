import 'package:flutter/material.dart';

Widget noDataAvailable({@required String message}) {
  return Center(
    child: Text(
      message.toString(),
      style: const TextStyle(fontSize: 16, color: Colors.black),
    ),
  );
}
