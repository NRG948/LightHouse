import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class PointData {
  double x;
  double y;
  AutoZoneId? autoZone;

  PointData({required this.x, required this.y, this.autoZone});

  /*
   * This one requires non-generated custom fromJson and toJson
   * functions because there's two possible data types it
   * can export ;-;
  */

  factory PointData.fromJson(Map<String, dynamic> json) {
    if (json["autoZone"] != null) {
      AutoZoneId? zone;
      for (var entry in autoZoneEnumMap.entries) {
        if (entry.value == json["autoZone"]) {
          zone = entry.key;
        }
      }
      return PointData(x: 0, y: 0, autoZone: zone);
    } else {
      return PointData(x: json["x"], y: json["y"]);
    }
  }
  Map<String, dynamic> toJson() {
    if (autoZone != null) {
      return {"autoZone": autoZone};
    } else {
      return {
        "x": x,
        "y": y,
      };
    }
  }
}

enum AutoZoneId {
  depot,
  outpost,
  tower,
  trenchDepot,
  bumpDepot,
  bumpOutpost,
  trenchOutpost,
}

/// As explained above, custom serialization logic is needed,
/// and this is part of it.
///
/// Make sure to update for each season!!!
const autoZoneEnumMap = {
  AutoZoneId.bumpDepot: "bumpDepot",
  AutoZoneId.bumpOutpost: "bumpOutpost",
  AutoZoneId.depot: "depot",
  AutoZoneId.outpost: "outpost",
  AutoZoneId.tower: "tower",
  AutoZoneId.trenchDepot: "trenchDepot",
  AutoZoneId.trenchOutpost: "trenchOutpost",
};
