class AlarmData {
  final List<Alarm>
      alarms; // Changed from alarmConfig to alarms for consistency with usage
  final TimConfig silentHours;

  AlarmData({required this.alarms, required this.silentHours});

  factory AlarmData.fromJson(Map<String, dynamic> json) {
    return AlarmData(
      alarms: (json['AlarmConfig'] as List)
          .map((e) => Alarm.fromJson(e as Map<String, dynamic>))
          .toList(),
      silentHours: TimConfig.fromJson(json['silentHours'] as List<dynamic>),
      // (json['silentHours'] as List)
      //     .map(
      //       (e) =>
      //           (e as List)
      //               .map((e) => (e as List).map((e) => e as int).toList())
      //               .toList(),
      //     )
      //     .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'AlarmConfig': alarms.map((e) => e.toJson()).toList(),
      'silentHours': silentHours,
    };
  }
}

class TimConfig {
  int? minFrom;
  int? minTo;
  int? hourFrom;
  int? hourTo;
  int? dayFrom; // Day of week
  int? dayTo; // Day of week
  int? dateFrom; // Day of month
  int? dateTo; // Day of month
  int? monthFrom;
  int? monthTo;
  List<int>? days;

  TimConfig({
    this.minFrom,
    this.minTo,
    this.hourFrom,
    this.hourTo,
    this.dayFrom,
    this.dayTo,
    this.dateFrom,
    this.dateTo,
    this.monthFrom,
    this.monthTo,
    this.days,
  });

  factory TimConfig.fromJson(List<dynamic> json) {
    List<int> getListAtIndex(int index) {
      if (json.length > index && json[index] is List) {
        return (json[index] as List)
            .map((e) {
              if (e is int) return e;
              // Add other potential type coercions if necessary, e.g., String to int
              return null; // Or throw an error for unexpected types
            })
            .whereType<int>() // Filters out nulls and non-integers
            .toList();
      }
      return []; // Return empty list if index is out of bounds or item is not a list
    }

    List<int> minL = getListAtIndex(0);
    List<int> hourL = getListAtIndex(1);
    List<int> dateL = getListAtIndex(2);
    List<int> monthL = getListAtIndex(3);
    List<int> dayL = getListAtIndex(4);

    return TimConfig(
      minFrom: minL.isNotEmpty ? minL[0] : null,
      minTo: minL.length > 1 ? minL[1] : null,
      hourFrom: hourL.isNotEmpty ? hourL[0] : null,
      hourTo: hourL.length > 1 ? hourL[1] : null,
      dayFrom: dayL.isNotEmpty ? dayL[0] : null,
      dayTo: dayL.length > 1 ? dayL[1] : null,
      dateFrom: dateL.isNotEmpty ? dateL[0] : null,
      dateTo: dateL.length > 1 ? dateL[1] : null,
      monthFrom: monthL.isNotEmpty ? monthL[0] : null,
      monthTo: monthL.length > 1 ? monthL[1] : null,
      days: dayL,
    );
  }

  List<List<int>> toJson() {
    List<int> toList(int? from, int? to) {
      final list = <int>[];
      if (from != null) {
        list.add(from);
        if (to != null) {
          list.add(to);
        }
      }
      return list;
    }

    return [
      toList(minFrom, minTo),
      toList(hourFrom, hourTo),
      toList(dateFrom, dateTo),
      toList(monthFrom, monthTo),
      // toList(dayFrom, dayTo),
      days ?? [],
    ];
  }
}

class Alarm {
  final TimConfig tim;
  final List<SoundConfig> sc;

  Alarm({required this.tim, required this.sc});

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      tim: TimConfig.fromJson(json['tim'] as List<dynamic>),
      sc: (json['SC'] as List)
          .map((e) => SoundConfig.fromJson(e as List<dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'tim': tim.toJson(), 'SC': sc.map((e) => e.toJson()).toList()};
  }
}

class SoundConfig {
  final int fileCount;
  final String type;
  final String folder;
  final String description;

  SoundConfig({
    required this.fileCount,
    required this.type,
    required this.folder,
    required this.description,
  });

  factory SoundConfig.fromJson(List<dynamic> json) {
    return SoundConfig(
      fileCount: json[0] as int,
      type: json[1] as String,
      folder: json[2] as String,
      description: json[3] as String,
    );
  }

  List<dynamic> toJson() {
    return [fileCount, type, folder, description];
  }
}
