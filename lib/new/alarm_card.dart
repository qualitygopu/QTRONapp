import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qtronapp/new/alaram_config.dart';

AlarmData alarmData = AlarmData(alarms: [], silentHours: TimConfig());
// The TIMItem class and its instance are no longer needed as TimConfig from alaram_config.dart will be used.
// class TIMItem { ... }
// TIMItem timItem = TIMItem(min: [], hour: [], day: [], month: [], date: []);

class AlarmSetting extends StatefulWidget {
  AlarmSetting({super.key});

  @override
  State<AlarmSetting> createState() => _AlarmSettingState();
}

class _AlarmSettingState extends State<AlarmSetting> {
  Future<void> fetchJsonFromUrl(String url) async {
    // Note: For UI to update in a StatelessWidget, you'd typically need to convert
    // this to a StatefulWidget and call setState, or use a state management solution.
    // try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonString = response.body;
      alarmData = AlarmData.fromJson(json.decode(jsonString));
      log('Data fetched successfully');
      // Example of accessing new TimConfig data:
      // if (alarmData.alarms.isNotEmpty) {
      //   log('First alarm dates: ${alarmData.alarms[0].tim.date}');
      // }
    } else {
      log('Failed to load data: ${response.statusCode}');
    }
    // } catch (e) {
    //   log('Error fetching data: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary Card'),
        actions: [
          IconButton(
            onPressed: () async {
              await fetchJsonFromUrl(
                'https://raw.githubusercontent.com/qualitygopu/files/refs/heads/main/alarmconfig.json',
              );
              setState(() {});
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: alarmData.alarms.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: alarmData.alarms.length,
              itemBuilder: (context, index) {
                final currentAlarm = alarmData.alarms[index];
                final timConfig = currentAlarm.tim;

                return AlarmCard(
                  // Pass the From/To properties directly
                  timeFrom: timConfig.hourFrom,
                  timeTo: timConfig.hourTo,
                  dayFrom: timConfig.dayFrom,
                  dayTo: timConfig.dayTo,
                  dateFrom: timConfig.dateFrom,
                  dateTo: timConfig.dateTo,
                  monthFrom: timConfig.monthFrom,
                  monthTo: timConfig.monthTo,
                  title: 'Alarm ${index + 1}',
                  // Note: minFrom and minTo are available in timConfig but not used by AlarmCard yet
                );
              },
            ),
    );
  }
}

class AlarmCard extends StatelessWidget {
  const AlarmCard({
    super.key,
    this.timeTo,
    this.timeFrom,
    this.dayTo,
    this.dayFrom,
    this.dateTo,
    this.dateFrom,
    this.monthTo,
    this.monthFrom,
    this.title = 'Alarm 01',
  });

  final String title;
  final int? timeTo,
      timeFrom,
      dayTo,
      dayFrom,
      dateTo,
      dateFrom,
      monthTo,
      monthFrom;

  @override
  Widget build(BuildContext context) {
    const List<String> daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.alarm),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_upward_outlined),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_downward_outlined),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        label: const Text('Edit'),
                        icon: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SummaryRow(
                  icon: Icons.timer_outlined,
                  iconColor: Colors.green,
                  label: 'Time',
                  value: '$timeFrom - $timeTo',
                  valueColor: Colors.green,
                ),
                SizedBox(height: 5),
                SummaryRow(
                  icon: Icons.calendar_month,
                  iconColor: Colors.red,
                  label: 'Days',
                  value:
                      '${daysOfWeek[dayFrom! - 1]} - ${daysOfWeek[dayTo! - 1]}',
                  valueColor: Colors.red,
                ),
                SizedBox(height: 5),
                SummaryRow(
                  icon: Icons.calendar_view_month,
                  iconColor: Colors.red,
                  label: 'Date',
                  value: '$dateFrom - $dateTo',
                  valueColor: Colors.red,
                ),
                SizedBox(height: 5),
                SummaryRow(
                  icon: Icons.calendar_month_rounded,
                  iconColor: Colors.red,
                  label: 'Month',
                  value: '$monthFrom - $monthTo',
                  valueColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  const SummaryRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 5),
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 18)),
        ),
        const SizedBox(width: 20),
        Text(value, style: TextStyle(fontSize: 18, color: valueColor)),
      ],
    );
  }
}
