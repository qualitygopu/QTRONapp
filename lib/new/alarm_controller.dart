import 'dart:developer';

import 'package:day_picker/day_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qtronapp/new/alaram_config.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AlarmController extends GetxController {
  // Make the timConfig state observable and initialize with default values.
  final timConfig = TimConfig(
          minFrom: 0,
          minTo: 0,
          hourFrom: 5,
          hourTo: 22,
          days: [1, 2, 3, 4, 5],
          monthFrom: 1,
          monthTo: 12,
          dateFrom: 1,
          dateTo: 31)
      .obs;

  /// Shows a time range picker and updates the state.
  Future<void> pickTimeRange(BuildContext context) async {
    // The picker can return null if dismissed.
    TimeRange? timeRange = await showTimeRangePicker(
        context: context,
        // Use current state for picker's initial values for better UX.
        start: TimeOfDay(hour: timConfig.value.hourFrom ?? 5, minute: 0),
        end: TimeOfDay(hour: timConfig.value.hourTo ?? 22, minute: 0),
        minDuration: const Duration(hours: 5),
        ticks: 24,
        fromText: 'Start Time',
        toText: 'End Time',
        use24HourFormat: false,
        interval: const Duration(hours: 1));

    // Only update state if a time range was selected.
    if (timeRange != null) {
      timConfig.update((val) {
        val?.hourFrom = timeRange.startTime.hour;
        val?.hourTo = timeRange.endTime.hour;
      });
    }
  }

  Future<void> pickDayRange(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select Days'),
            content: SelectDays(),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Save')),
            ],
          );
        });
  }

  Future<void> pickDateRange(BuildContext context) async {
    final NumberRange? dateRange = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SelectNumberRange(
            initialFrom: timConfig.value.dateFrom ?? 1,
            initialTo: timConfig.value.dateTo ?? 31,
            title: 'Select Date Range',
            labelFrom: 'From Date',
            labelTo: 'To Date',
            minValue: 1,
            maxValue: 31,
          );
        });
    log('dateRange: $dateRange');
    if (dateRange != null) {
      timConfig.update((val) {
        val?.dateFrom = dateRange.from;
        val?.dateTo = dateRange.to;
      });
    }
  }

  Future<void> pickMonthRange(BuildContext context) async {
    final NumberRange? monthRange = await showDialog<NumberRange>(
        context: context,
        builder: (context) {
          return SelectNumberRange(
            initialFrom: timConfig.value.monthFrom ?? 1,
            initialTo: timConfig.value.monthTo ?? 12,
            title: 'Select Month Range',
            labelFrom: 'From Month',
            labelTo: 'To Month',
            minValue: 1,
            maxValue: 12,
          );
        });
    if (monthRange != null) {
      timConfig.update((val) {
        val?.monthFrom = monthRange.from;
        val?.monthTo = monthRange.to;
      });
    }
  }
}

class SelectDateRange extends StatelessWidget {
  const SelectDateRange({super.key});

  @override
  Widget build(BuildContext context) {
    final AlarmController controller = Get.find();
    TextEditingController _fromController = TextEditingController(
        text: controller.timConfig.value.dateFrom.toString());
    TextEditingController _toController = TextEditingController(
        text: controller.timConfig.value.dateTo.toString());
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor:
          Colors.white, // Default background, can be overridden if needed
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.purple.shade50, // Light purple as seen in the image
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom Date Range',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _fromController,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      labelText: 'From Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _toController,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      labelText: 'To Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle Cancel action
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    controller.timConfig.update((val) {
                      val?.dateFrom = int.parse(_fromController.text);
                      val?.dateTo = int.parse(_toController.text);
                    });
                    // DateRange selectedRange = DateRange(
                    //     from: int.parse(_fromController.text),
                    //     to: int.parse(_toController.text));
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SelectNumberRange extends StatelessWidget {
  const SelectNumberRange(
      {super.key,
      required this.title,
      required this.labelFrom,
      required this.labelTo,
      required this.minValue,
      required this.maxValue,
      required this.initialFrom,
      required this.initialTo});

  final String title, labelFrom, labelTo;
  final int minValue, maxValue, initialFrom, initialTo;

  @override
  Widget build(BuildContext context) {
    TextEditingController _fromController =
        TextEditingController(text: initialFrom.toString());
    TextEditingController _toController =
        TextEditingController(text: initialTo.toString());
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor:
          Colors.white, // Default background, can be overridden if needed
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.purple.shade50, // Light purple as seen in the image
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (int.parse(value) < minValue) {
                          _fromController.text = minValue.toString();
                        }
                      }
                    },
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    controller: _fromController,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      labelText: labelFrom,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (int.parse(value) > maxValue) {
                          _toController.text = maxValue.toString();
                        }
                      }
                    },
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    controller: _toController,
                    keyboardType: TextInputType.numberWithOptions(),
                    decoration: InputDecoration(
                      labelText: labelTo,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle Cancel action
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    // controller.timConfig.update((val) {
                    //   val?.dateFrom = int.parse(_fromController.text);
                    //   val?.dateTo = int.parse(_toController.text);
                    // });
                    NumberRange selectedRange = NumberRange(
                        from: int.parse(_fromController.text),
                        to: int.parse(_toController.text));
                    Navigator.of(context).pop(selectedRange);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NumberRange {
  final int from;
  final int to;

  NumberRange({required this.from, required this.to});
}

class SelectDays extends StatefulWidget {
  const SelectDays({super.key});

  @override
  State<SelectDays> createState() => _SelectDaysState();
}

class _SelectDaysState extends State<SelectDays> {
  final AlarmController controller = Get.find();
  late List<DayInWeek> _days;

  @override
  void initState() {
    super.initState();
    _days = [
      DayInWeek("S",
          dayKey: "0",
          isSelected: controller.timConfig.value.days?.contains(0) ?? false),
      DayInWeek("M",
          dayKey: "1",
          isSelected: controller.timConfig.value.days?.contains(1) ?? false),
      DayInWeek("T",
          dayKey: "2",
          isSelected: controller.timConfig.value.days?.contains(2) ?? false),
      DayInWeek("W",
          dayKey: "3",
          isSelected: controller.timConfig.value.days?.contains(3) ?? false),
      DayInWeek("T",
          dayKey: "4",
          isSelected: controller.timConfig.value.days?.contains(4) ?? false),
      DayInWeek("F",
          dayKey: "5",
          isSelected: controller.timConfig.value.days?.contains(5) ?? false),
      DayInWeek("S",
          dayKey: "6",
          isSelected: controller.timConfig.value.days?.contains(6) ?? false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SelectWeekDays(
      days: _days,
      fontSize: 20,
      padding: 0,

      unSelectedDayTextColor: Colors.black,
      width: double.infinity,
      selectedDaysFillColor: Colors.orangeAccent,
      // showSelectedDays: true,
      // highlightSelectedDay: true,
      // highlightColor: Colors.blue,
      // selectedBorderColor: Colors.blue,
      // dayNameColor: Colors.black,
      // dayNumberColor: Colors.black,
      backgroundColor: Colors.transparent,
      onSelect: (selectedDays) {
        final List<int> days =
            selectedDays.map((day) => int.parse(day)).toList();
        controller.timConfig.update((val) {
          val?.days = days;
        });
        // Navigator.of(context).pop();
      },
    );
  }
}
