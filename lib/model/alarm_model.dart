// To parse this JSON data, do
//
//     final alarmModel = alarmModelFromJson(jsonString);

import 'dart:convert';

AlarmModel alarmModelFromJson(String str) =>
    AlarmModel.fromJson(json.decode(str));

String alarmModelToJson(AlarmModel data) => json.encode(data.toJson());

class AlarmModel {
  AlarmModel({
    this.id,
    this.dateSet,
    this.dateUp,
    this.secondDiff,
    this.isActive,
  });

  int id;
  DateTime dateSet;
  DateTime dateUp;
  int secondDiff;
  int isActive;

  factory AlarmModel.fromJson(Map<String, dynamic> json) => AlarmModel(
        id: json["id"] == null ? null : json["id"],
        dateSet:
            json["DateSet"] == null ? null : DateTime.parse(json["DateSet"]),
        dateUp: json["DateUp"] == null ? null : DateTime.parse(json["DateUp"]),
        secondDiff: json["SecondDiff"] == null ? null : json["SecondDiff"],
        isActive: json["isActive"] == null ? null : json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "DateSet": dateSet == null ? null : dateSet.toIso8601String(),
        "DateUp": dateUp == null ? null : dateUp.toIso8601String(),
        "SecondDiff": secondDiff == null ? null : secondDiff,
        "isActive": isActive == null ? null : isActive,
      };
}
