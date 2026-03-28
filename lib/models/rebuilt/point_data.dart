import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PointData {
  double x;
  double y;
  AutoZone? autoZone;

  PointData({required this.x, required this.y, this.autoZone});

  /*
   * This one requires non-generated custom fromJson and toJson
   * functions because there's two possible data types it 
   * can export ;-;
  */

  factory PointData.fromJson(Map<String, dynamic> json) {
    if (json["autoZone"] != null) {
      AutoZone? zone;
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

enum AutoZone {
  depot,
  outpost,
  tower,
  trenchDepot,
  bumpDepot,
  bumpOutpost,
  trenchOutpost,
}

// As explained above, custom serialization logic is needed,
// and this is part of it
const autoZoneEnumMap = {
  AutoZone.bumpDepot: "bumpDepot",
  AutoZone.bumpOutpost: "bumpOutpost",
  AutoZone.depot: "depot",
  AutoZone.outpost: "outpost",
  AutoZone.tower: "tower",
  AutoZone.trenchDepot: "trenchDepot",
  AutoZone.trenchOutpost: "trenchOutpost",
};
