import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qtronapp/new/alarm_controller.dart';

/// Manages the state and logic for the TimeTile widget.

class SectionTile extends StatelessWidget {
  SectionTile(
      {super.key,
      required this.title,
      required this.value,
      required this.onTap});

  final String title, value;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.alarm,
            size: 30,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              // Wrap with Obx to make the widget reactive to state changes.
              Text(
                value,
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          Spacer(),
          IconButton(
            // Call the controller method on press.
            onPressed: () {
              onTap();
            },
            icon: const Icon(
              Icons.edit,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class Weekformatter {
  static String formatDays(List<int>? days) {
    if (days == null || days.isEmpty) {
      return 'No days selected';
    }

    final List<String> dayAbbreviations = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat'
    ];

    // Sort the days to ensure consistent output
    final sortedDays = days.toList()..sort();

    // Check for all days selected
    if (sortedDays.length == 7) {
      return 'Everyday';
    }

    // // Check for weekdays
    // if (sortedDays.length == 5 && sortedDays.every((day) => day >= 1 && day <= 5)) {
    //   return 'Weekdays';
    // }

    // // Check for weekends
    // if (sortedDays.length == 2 && sortedDays.contains(0) && sortedDays.contains(6)) {
    //   return 'Weekends';
    // }

    // Format individual days
    return sortedDays.map((dayIndex) {
      if (dayIndex >= 0 && dayIndex < dayAbbreviations.length) {
        return dayAbbreviations[dayIndex];
      }
      return ''; // Should not happen with valid input
    }).join(', ');
  }
}
