import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qtronapp/new/alarm_controller.dart';
import 'package:qtronapp/new/formatter.dart';

/// Manages the state and logic for the TimeTile widget.

class DayTile extends StatelessWidget {
  DayTile({super.key});

  // Instantiate the controller. GetX will manage its lifecycle.
  final AlarmController controller = Get.put(AlarmController());

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
                'Days of the Week ',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              // Wrap with Obx to make the widget reactive to state changes.
              Obx(() => Text(
                    formatDays(controller.timConfig.value.days),
                    style: TextStyle(fontSize: 18),
                  ))
            ],
          ),
          Spacer(),
          IconButton(
            // Call the controller method on press.
            onPressed: () => controller.pickDayRange(context),
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
