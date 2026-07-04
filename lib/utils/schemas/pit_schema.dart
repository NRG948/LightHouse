import 'package:json_schema/json_schema.dart';

Map<String, dynamic> get pitSchema {
  return {
    r'$schema': 'https://json-schema.org/draft/2020-12/schema',
    'title': 'Pit Data Entry Schema',
    'description': 'Validates DataEntry.exportData for the Pit layout',
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
      'teamName': {
        'type': 'string',
      },

      // --- General Page ---
      'shooterType': {
        'type': 'string',
        'enum': ['Fixed', 'Turret'],
      },
      'intakeType': {
        'type': 'string',
        'enum': ['Ground', 'Outpost'],
      },
      'fuelCapacity': {
        'type': 'integer',
        'minimum': 0,
      },
      'bps': {
        'type': 'integer',
        'minimum': 0,
      },
      'weight': {
        'type': 'integer',
        'minimum': 0,
      },
      'width': {
        'type': 'integer',
        'minimum': 0,
      },
      'length': {
        'type': 'integer',
        'minimum': 0,
      },
      'drivetrain': {
        'type': 'string',
      },
      'mechanisms': {
        'type': 'string',
      },

      // --- Auto Page ---
      'autoPaths': {
        'type': 'array',
        'items': {
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
            'fuelScored': {'type': 'integer', 'minimum': 0},
            'crossedMidline': {'type': 'boolean'},
          },
          'required': [
            'path',
            'attemptedClimb',
            'climbSuccessful',
            'climbLevel',
            'shotPreload',
            'fuelScored',
            'crossedMidline',
          ],
        },
      },

      // --- Teleop Page ---
      'canGoBump': {
        'type': 'string',
        'enum': ['unable', 'able', 'preferred'],
      },
      'canGoTrench': {
        'type': 'string',
        'enum': ['unable', 'able', 'preferred'],
      },
      'canShootTrench': {
        'type': 'string',
        'enum': ['unable', 'able', 'preferred'],
      },
      'canShootHub': {
        'type': 'string',
        'enum': ['unable', 'able', 'preferred'],
      },
      'canShootTower': {
        'type': 'string',
        'enum': ['unable', 'able', 'preferred'],
      },
      'canShootAnywhere': {
        'type': 'string',
        'enum': ['unable', 'able', 'preferred'],
      },
      'canFeed': {
        'type': 'string',
        'enum': ['unable', 'able', 'preferred'],
      },
      'canDefend': {
        'type': 'string',
        'enum': ['unable', 'able', 'preferred'],
      },
      'canHoard': {
        'type': 'string',
        'enum': ['unable', 'able', 'preferred'],
      },
      'canPass': {
        'type': 'string',
        'enum': ['unable', 'able', 'preferred'],
      },
      'canPushOverBump': {
        'type': 'string',
        'enum': ['unable', 'able', 'preferred'],
      },
      'canPushThroughTrench': {
        'type': 'string',
        'enum': ['unable', 'able', 'preferred'],
      },
      'cycleTime': {
        'type': 'integer',
        'minimum': 0,
      },

      // --- Endgame Page ---
      'climb': {
        'type': 'object',
        'properties': {
          'attempted': {'type': 'boolean'},
          'startTime': {'type': 'string'},
          'region': {
            'type': 'array',
            'items': {'type': 'string'},
          },
          'level': {
            'type': 'string',
            'enum': ['none', 'L1', 'L2', 'L3'],
          },
        },
        'required': ['attempted', 'startTime', 'region', 'level'],
      },
      'canShootEndgame': {
        'type': 'string',
        'enum': ['unable', 'able', 'preferred'],
      },
      'idealPartner': {
        'type': 'string',
      },
      'comments': {
        'type': 'string',
      },

      // --- Metadata (added by saveExport in filemgr.dart) ---
      'layout': {
        'type': 'string',
        'enum': ['Pit'],
      },
      'exportName': {
        'type': 'string',
      },
      'timestamp': {
        'type': 'string',
      },
    },
    'required': [
      'teamNumber',
      'layout',
      'exportName',
      'timestamp',
    ],
  };
}

final JsonSchema pitJsonSchema = JsonSchema.create(pitSchema);
