import 'package:json_schema/json_schema.dart';

Map<String, dynamic> get atlasSchema {
  return {
    r'$schema': 'https://json-schema.org/draft/2020-12/schema',
    'title': 'Atlas Data Entry Schema',
    'description': 'Validates DataEntry.exportData for the Atlas layout',
    'type': 'object',
    'properties': {
      // --- Setup Page ---
      'scouterName': {
        'type': 'string',
      },
      'teamNumber': {
        'type': 'integer',
        'minimum': 0,
      },
      'matchNumber': {
        'type': 'integer',
        'minimum': 0,
      },
      'replay': {
        'type': 'boolean',
      },
      'matchType': {
        'type': 'string',
        'enum': ['Qualifications', 'Playoffs', 'Finals'],
      },
      'driverStation': {
        'type': 'string',
        'enum': [
          'Red 1',
          'Red 2',
          'Red 3',
          'Blue 1',
          'Blue 2',
          'Blue 3',
        ],
      },
      'matchPrediction': {
        'type': 'object',
        'properties': {
          'prediction': {
            'type': 'string',
            'enum': ['red', 'blue', ''],
          },
          'time': {
            'type': 'integer',
          },
        },
        'required': ['prediction', 'time'],
      },

      // --- Auto Page ---
      'autoPath': {
        'type': 'object',
        'properties': {
          'path': {
            'type': 'array',
            'items': {
              'oneOf': [
                {'type': 'string'},
                {
                  'type': 'array',
                  'items': {'type': 'number'},
                  'minItems': 2,
                  'maxItems': 2,
                },
              ],
            },
          },
          'attemptedClimb': {'type': 'boolean'},
          'climbSuccessful': {
            'type': ['boolean', 'null']
          },
          'climbLevel': {
            'type': ['string', 'null']
          },
          'shotPreload': {'type': 'boolean'},
        },
        'required': [
          'path',
          'attemptedClimb',
          'climbSuccessful',
          'climbLevel',
          'shotPreload',
        ],
      },
      'autoCrossedMidline': {
        'type': 'boolean',
      },

      // --- Offense Page ---
      'scoringLocations': {
        'type': 'object',
        'description':
            'Region ID → per-cycle accuracy ratings. Keys are zone IDs (depot_corner, depot_trench, depot_wall, depot_bump, tower, hub, outpost_wall, outpost_bump, outpost_corner, outpost_trench). Values are arrays where each element is null (unset), "1", "2", or "3".',
        'additionalProperties': {
          'type': 'array',
          'items': {
            'oneOf': [
              {
                'type': 'string',
                'enum': ['1', '2', '3']
              },
              {'type': 'null'},
            ],
          },
        },
      },
      'isBeingDefended': {
        'type': 'boolean',
      },
      'isCounterDefending': {
        'type': 'object',
        'properties': {
          'isChecked': {'type': 'boolean'},
          'selection': {
            'type': ['string', 'null']
          },
        },
        'required': ['isChecked', 'selection'],
      },
      'isHerding': {
        'type': 'object',
        'properties': {
          'isChecked': {'type': 'boolean'},
          'selection': {
            'type': ['string', 'null']
          },
        },
        'required': ['isChecked', 'selection'],
      },
      'isFeeding': {
        'type': 'object',
        'properties': {
          'isChecked': {'type': 'boolean'},
          'selection': {
            'type': ['string', 'null']
          },
        },
        'required': ['isChecked', 'selection'],
      },

      // --- Defense Page ---
      'isAccessDefending': {
        'type': 'object',
        'properties': {
          'isChecked': {'type': 'boolean'},
          'selection': {
            'type': ['string', 'null']
          },
        },
        'required': ['isChecked', 'selection'],
      },
      'isCenterDefending': {
        'type': 'object',
        'properties': {
          'isChecked': {'type': 'boolean'},
          'selection': {
            'type': ['string', 'null']
          },
        },
        'required': ['isChecked', 'selection'],
      },
      'isAllianceDefending': {
        'type': 'object',
        'properties': {
          'isChecked': {'type': 'boolean'},
          'selection': {
            'type': ['string', 'null']
          },
        },
        'required': ['isChecked', 'selection'],
      },
      'isStealing': {
        'type': 'object',
        'properties': {
          'isChecked': {'type': 'boolean'},
          'selection': {
            'type': ['string', 'null']
          },
        },
        'required': ['isChecked', 'selection'],
      },

      // --- Endgame Page ---
      'tags': {
        'type': 'array',
        'items': {'type': 'string'},
      },
      'climb': {
        'type': 'object',
        'properties': {
          'attempted': {'type': 'boolean'},
          'startTime': {'type': 'string'},
          'region': {
            'oneOf': [
              {'type': 'string'},
              {
                'type': 'array',
                'items': {'type': 'string'},
              },
            ],
          },
          'level': {
            'type': 'string',
            'enum': ['none', 'L1', 'L2', 'L3'],
          },
        },
        'required': ['attempted', 'startTime', 'region', 'level'],
      },
      'scoring': {
        'type': 'string',
        'enum': ['', '1', '2', '3', '4', '5'],
      },
      'dataQuality': {
        'type': 'number',
        'minimum': 0,
        'maximum': 5,
      },
      'comments': {
        'type': 'string',
      },

      // --- Metadata (added by saveExport in filemgr.dart) ---
      'layout': {
        'type': 'string',
        'enum': ['Atlas'],
      },
      'exportName': {
        'type': 'string',
      },
      'timestamp': {
        'type': 'string',
      },
    },
    'required': [
      'scouterName',
      'teamNumber',
      'matchNumber',
      'matchType',
      'driverStation',
      'dataQuality',
      'layout',
      'exportName',
      'timestamp',
    ],
  };
}

final JsonSchema atlasJsonSchema = JsonSchema.create(atlasSchema);
