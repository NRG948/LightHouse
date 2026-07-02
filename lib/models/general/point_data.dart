import 'package:json_annotation/json_annotation.dart';

/// This is an exception to the "game agnostic code never depends on game-specific code"
/// convention. I just can't think of a better way.
import 'package:lighthouse/models/rebuilt/auto_zone_id.dart';

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
      return {"autoZone": autoZoneEnumMap[autoZone]};
    } else {
      return {
        "x": x,
        "y": y,
      };
    }
  }
}
