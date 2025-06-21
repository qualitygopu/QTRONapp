import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qtronapp/new/alarm_controller.dart';
import 'package:qtronapp/new/formatter.dart';
import 'package:qtronapp/new/section_tile.dart';

class AlarmConfigScreen extends StatelessWidget {
  AlarmConfigScreen({super.key});

  final AlarmController controller = Get.put(AlarmController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Config'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
            () => ListView(
              children: [
                SectionTItle(
                  title: 'Time and Day Settings',
                ),
                SectionTile(
                    title: 'Time Range',
                    value:
                        '${amPm(controller.timConfig.value.hourFrom ?? 0)} - ${amPm(controller.timConfig.value.hourTo ?? 0)}',
                    onTap: () => controller.pickTimeRange(context)),
                SectionTile(
                    title: 'Days of the Week',
                    value: formatDays(controller.timConfig.value.days),
                    onTap: () => controller.pickDayRange(context)),
                SectionTile(
                    title: 'Date Range',
                    value:
                        'From ${controller.timConfig.value.dateFrom} To ${controller.timConfig.value.dateTo}',
                    onTap: () {
                      controller.pickDateRange(context);
                    }),
                SectionTile(
                    title: 'Month Range',
                    value:
                        '${controller.timConfig.value.monthFrom} - ${controller.timConfig.value.monthTo}',
                    onTap: () => controller.pickMonthRange(context))
              ],
            ),
          )),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: ElevatedButton(
              onPressed: () {
                final js = controller.timConfig.toJson();
                log('js: $js');
              },
              child: Text('Save')),
        ),
      ),
    );
  }
}

class SectionTItle extends StatelessWidget {
  const SectionTItle({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      color: Colors.grey[300],
      child: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
