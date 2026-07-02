import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum AutoZoneId {
  depot,
  outpost,
  tower,
  trenchDepot,
  bumpDepot,
  bumpOutpost,
  trenchOutpost,
}

/// As explained in point_data.dart, custom serialization logic is needed,
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
