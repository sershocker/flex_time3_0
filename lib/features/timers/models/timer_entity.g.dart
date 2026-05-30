// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTimerEntityCollection on Isar {
  IsarCollection<TimerEntity> get timerEntitys => this.collection();
}

const TimerEntitySchema = CollectionSchema(
  name: r'TimerEntity',
  id: 7226858316023179542,
  properties: {
    r'description': PropertySchema(
      id: 0,
      name: r'description',
      type: IsarType.string,
    ),
    r'endDate': PropertySchema(
      id: 1,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'eventId': PropertySchema(id: 2, name: r'eventId', type: IsarType.long),
    r'progressColor': PropertySchema(
      id: 3,
      name: r'progressColor',
      type: IsarType.long,
    ),
    r'startDate': PropertySchema(
      id: 4,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(id: 5, name: r'title', type: IsarType.string),
    r'unitType': PropertySchema(
      id: 6,
      name: r'unitType',
      type: IsarType.byte,
      enumMap: _TimerEntityunitTypeEnumValueMap,
    ),
    r'viewType': PropertySchema(
      id: 7,
      name: r'viewType',
      type: IsarType.byte,
      enumMap: _TimerEntityviewTypeEnumValueMap,
    ),
  },

  estimateSize: _timerEntityEstimateSize,
  serialize: _timerEntitySerialize,
  deserialize: _timerEntityDeserialize,
  deserializeProp: _timerEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _timerEntityGetId,
  getLinks: _timerEntityGetLinks,
  attach: _timerEntityAttach,
  version: '3.3.2',
);

int _timerEntityEstimateSize(
  TimerEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _timerEntitySerialize(
  TimerEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.description);
  writer.writeDateTime(offsets[1], object.endDate);
  writer.writeLong(offsets[2], object.eventId);
  writer.writeLong(offsets[3], object.progressColor);
  writer.writeDateTime(offsets[4], object.startDate);
  writer.writeString(offsets[5], object.title);
  writer.writeByte(offsets[6], object.unitType.index);
  writer.writeByte(offsets[7], object.viewType.index);
}

TimerEntity _timerEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TimerEntity();
  object.description = reader.readStringOrNull(offsets[0]);
  object.endDate = reader.readDateTimeOrNull(offsets[1]);
  object.eventId = reader.readLongOrNull(offsets[2]);
  object.id = id;
  object.progressColor = reader.readLong(offsets[3]);
  object.startDate = reader.readDateTimeOrNull(offsets[4]);
  object.title = reader.readString(offsets[5]);
  object.unitType =
      _TimerEntityunitTypeValueEnumMap[reader.readByteOrNull(offsets[6])] ??
      UnitType.seconds;
  object.viewType =
      _TimerEntityviewTypeValueEnumMap[reader.readByteOrNull(offsets[7])] ??
      ViewType.circle;
  return object;
}

P _timerEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (_TimerEntityunitTypeValueEnumMap[reader.readByteOrNull(offset)] ??
              UnitType.seconds)
          as P;
    case 7:
      return (_TimerEntityviewTypeValueEnumMap[reader.readByteOrNull(offset)] ??
              ViewType.circle)
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TimerEntityunitTypeEnumValueMap = {
  'seconds': 0,
  'minutes': 1,
  'hours': 2,
  'days': 3,
  'weeks': 4,
  'months': 5,
  'years': 6,
  'combined': 7,
};
const _TimerEntityunitTypeValueEnumMap = {
  0: UnitType.seconds,
  1: UnitType.minutes,
  2: UnitType.hours,
  3: UnitType.days,
  4: UnitType.weeks,
  5: UnitType.months,
  6: UnitType.years,
  7: UnitType.combined,
};
const _TimerEntityviewTypeEnumValueMap = {'circle': 0, 'line': 1};
const _TimerEntityviewTypeValueEnumMap = {0: ViewType.circle, 1: ViewType.line};

Id _timerEntityGetId(TimerEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _timerEntityGetLinks(TimerEntity object) {
  return [];
}

void _timerEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  TimerEntity object,
) {
  object.id = id;
}

extension TimerEntityQueryWhereSort
    on QueryBuilder<TimerEntity, TimerEntity, QWhere> {
  QueryBuilder<TimerEntity, TimerEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TimerEntityQueryWhere
    on QueryBuilder<TimerEntity, TimerEntity, QWhereClause> {
  QueryBuilder<TimerEntity, TimerEntity, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TimerEntityQueryFilter
    on QueryBuilder<TimerEntity, TimerEntity, QFilterCondition> {
  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'description'),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'description'),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  descriptionEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  endDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'endDate'),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  endDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'endDate'),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> endDateEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endDate', value: value),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  endDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'endDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> endDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'endDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> endDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'endDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  eventIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'eventId'),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  eventIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'eventId'),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> eventIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'eventId', value: value),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  eventIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'eventId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> eventIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'eventId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> eventIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'eventId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  progressColorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'progressColor', value: value),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  progressColorGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'progressColor',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  progressColorLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'progressColor',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  progressColorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'progressColor',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  startDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startDate'),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  startDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startDate'),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  startDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startDate', value: value),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  startDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  startDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  startDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> titleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> titleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> unitTypeEqualTo(
    UnitType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unitType', value: value),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  unitTypeGreaterThan(UnitType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unitType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  unitTypeLessThan(UnitType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unitType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> unitTypeBetween(
    UnitType lower,
    UnitType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unitType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> viewTypeEqualTo(
    ViewType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'viewType', value: value),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  viewTypeGreaterThan(ViewType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'viewType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition>
  viewTypeLessThan(ViewType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'viewType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterFilterCondition> viewTypeBetween(
    ViewType lower,
    ViewType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'viewType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TimerEntityQueryObject
    on QueryBuilder<TimerEntity, TimerEntity, QFilterCondition> {}

extension TimerEntityQueryLinks
    on QueryBuilder<TimerEntity, TimerEntity, QFilterCondition> {}

extension TimerEntityQuerySortBy
    on QueryBuilder<TimerEntity, TimerEntity, QSortBy> {
  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByProgressColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressColor', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy>
  sortByProgressColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressColor', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByUnitType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitType', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByUnitTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitType', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByViewType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'viewType', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> sortByViewTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'viewType', Sort.desc);
    });
  }
}

extension TimerEntityQuerySortThenBy
    on QueryBuilder<TimerEntity, TimerEntity, QSortThenBy> {
  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eventId', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByProgressColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressColor', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy>
  thenByProgressColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressColor', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByUnitType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitType', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByUnitTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitType', Sort.desc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByViewType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'viewType', Sort.asc);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QAfterSortBy> thenByViewTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'viewType', Sort.desc);
    });
  }
}

extension TimerEntityQueryWhereDistinct
    on QueryBuilder<TimerEntity, TimerEntity, QDistinct> {
  QueryBuilder<TimerEntity, TimerEntity, QDistinct> distinctByDescription({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QDistinct> distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QDistinct> distinctByEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eventId');
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QDistinct> distinctByProgressColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progressColor');
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QDistinct> distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QDistinct> distinctByUnitType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unitType');
    });
  }

  QueryBuilder<TimerEntity, TimerEntity, QDistinct> distinctByViewType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'viewType');
    });
  }
}

extension TimerEntityQueryProperty
    on QueryBuilder<TimerEntity, TimerEntity, QQueryProperty> {
  QueryBuilder<TimerEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TimerEntity, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<TimerEntity, DateTime?, QQueryOperations> endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<TimerEntity, int?, QQueryOperations> eventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eventId');
    });
  }

  QueryBuilder<TimerEntity, int, QQueryOperations> progressColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressColor');
    });
  }

  QueryBuilder<TimerEntity, DateTime?, QQueryOperations> startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<TimerEntity, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<TimerEntity, UnitType, QQueryOperations> unitTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unitType');
    });
  }

  QueryBuilder<TimerEntity, ViewType, QQueryOperations> viewTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'viewType');
    });
  }
}
