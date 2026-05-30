// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_type.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDayTypeCollection on Isar {
  IsarCollection<DayType> get dayTypes => this.collection();
}

const DayTypeSchema = CollectionSchema(
  name: r'DayType',
  id: -902219907311551032,
  properties: {
    r'backgroundColor': PropertySchema(
      id: 0,
      name: r'backgroundColor',
      type: IsarType.long,
    ),
    r'endHour': PropertySchema(id: 1, name: r'endHour', type: IsarType.long),
    r'endMinute': PropertySchema(
      id: 2,
      name: r'endMinute',
      type: IsarType.long,
    ),
    r'isWorkDay': PropertySchema(
      id: 3,
      name: r'isWorkDay',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(id: 4, name: r'name', type: IsarType.string),
    r'startHour': PropertySchema(
      id: 5,
      name: r'startHour',
      type: IsarType.long,
    ),
    r'startMinute': PropertySchema(
      id: 6,
      name: r'startMinute',
      type: IsarType.long,
    ),
    r'textColor': PropertySchema(
      id: 7,
      name: r'textColor',
      type: IsarType.long,
    ),
  },

  estimateSize: _dayTypeEstimateSize,
  serialize: _dayTypeSerialize,
  deserialize: _dayTypeDeserialize,
  deserializeProp: _dayTypeDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _dayTypeGetId,
  getLinks: _dayTypeGetLinks,
  attach: _dayTypeAttach,
  version: '3.3.2',
);

int _dayTypeEstimateSize(
  DayType object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _dayTypeSerialize(
  DayType object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.backgroundColor);
  writer.writeLong(offsets[1], object.endHour);
  writer.writeLong(offsets[2], object.endMinute);
  writer.writeBool(offsets[3], object.isWorkDay);
  writer.writeString(offsets[4], object.name);
  writer.writeLong(offsets[5], object.startHour);
  writer.writeLong(offsets[6], object.startMinute);
  writer.writeLong(offsets[7], object.textColor);
}

DayType _dayTypeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DayType();
  object.backgroundColor = reader.readLong(offsets[0]);
  object.endHour = reader.readLongOrNull(offsets[1]);
  object.endMinute = reader.readLongOrNull(offsets[2]);
  object.id = id;
  object.isWorkDay = reader.readBool(offsets[3]);
  object.name = reader.readString(offsets[4]);
  object.startHour = reader.readLongOrNull(offsets[5]);
  object.startMinute = reader.readLongOrNull(offsets[6]);
  object.textColor = reader.readLong(offsets[7]);
  return object;
}

P _dayTypeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dayTypeGetId(DayType object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dayTypeGetLinks(DayType object) {
  return [];
}

void _dayTypeAttach(IsarCollection<dynamic> col, Id id, DayType object) {
  object.id = id;
}

extension DayTypeQueryWhereSort on QueryBuilder<DayType, DayType, QWhere> {
  QueryBuilder<DayType, DayType, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DayTypeQueryWhere on QueryBuilder<DayType, DayType, QWhereClause> {
  QueryBuilder<DayType, DayType, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DayType, DayType, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DayType, DayType, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterWhereClause> idBetween(
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

extension DayTypeQueryFilter
    on QueryBuilder<DayType, DayType, QFilterCondition> {
  QueryBuilder<DayType, DayType, QAfterFilterCondition> backgroundColorEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'backgroundColor', value: value),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition>
  backgroundColorGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'backgroundColor',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> backgroundColorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'backgroundColor',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> backgroundColorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'backgroundColor',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> endHourIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'endHour'),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> endHourIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'endHour'),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> endHourEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endHour', value: value),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> endHourGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'endHour',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> endHourLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'endHour',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> endHourBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'endHour',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> endMinuteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'endMinute'),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> endMinuteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'endMinute'),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> endMinuteEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endMinute', value: value),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> endMinuteGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'endMinute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> endMinuteLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'endMinute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> endMinuteBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'endMinute',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DayType, DayType, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DayType, DayType, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DayType, DayType, QAfterFilterCondition> isWorkDayEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isWorkDay', value: value),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> startHourIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startHour'),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> startHourIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startHour'),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> startHourEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startHour', value: value),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> startHourGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startHour',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> startHourLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startHour',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> startHourBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startHour',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> startMinuteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startMinute'),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> startMinuteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startMinute'),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> startMinuteEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startMinute', value: value),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> startMinuteGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startMinute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> startMinuteLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startMinute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> startMinuteBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startMinute',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> textColorEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'textColor', value: value),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> textColorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'textColor',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> textColorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'textColor',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DayType, DayType, QAfterFilterCondition> textColorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'textColor',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DayTypeQueryObject
    on QueryBuilder<DayType, DayType, QFilterCondition> {}

extension DayTypeQueryLinks
    on QueryBuilder<DayType, DayType, QFilterCondition> {}

extension DayTypeQuerySortBy on QueryBuilder<DayType, DayType, QSortBy> {
  QueryBuilder<DayType, DayType, QAfterSortBy> sortByBackgroundColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColor', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByBackgroundColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColor', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByEndHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endHour', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByEndHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endHour', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByEndMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinute', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByEndMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinute', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByIsWorkDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWorkDay', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByIsWorkDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWorkDay', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByStartHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startHour', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByStartHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startHour', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByStartMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinute', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByStartMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinute', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByTextColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textColor', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> sortByTextColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textColor', Sort.desc);
    });
  }
}

extension DayTypeQuerySortThenBy
    on QueryBuilder<DayType, DayType, QSortThenBy> {
  QueryBuilder<DayType, DayType, QAfterSortBy> thenByBackgroundColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColor', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByBackgroundColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backgroundColor', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByEndHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endHour', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByEndHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endHour', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByEndMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinute', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByEndMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinute', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByIsWorkDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWorkDay', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByIsWorkDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isWorkDay', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByStartHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startHour', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByStartHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startHour', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByStartMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinute', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByStartMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinute', Sort.desc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByTextColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textColor', Sort.asc);
    });
  }

  QueryBuilder<DayType, DayType, QAfterSortBy> thenByTextColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textColor', Sort.desc);
    });
  }
}

extension DayTypeQueryWhereDistinct
    on QueryBuilder<DayType, DayType, QDistinct> {
  QueryBuilder<DayType, DayType, QDistinct> distinctByBackgroundColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backgroundColor');
    });
  }

  QueryBuilder<DayType, DayType, QDistinct> distinctByEndHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endHour');
    });
  }

  QueryBuilder<DayType, DayType, QDistinct> distinctByEndMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endMinute');
    });
  }

  QueryBuilder<DayType, DayType, QDistinct> distinctByIsWorkDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isWorkDay');
    });
  }

  QueryBuilder<DayType, DayType, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DayType, DayType, QDistinct> distinctByStartHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startHour');
    });
  }

  QueryBuilder<DayType, DayType, QDistinct> distinctByStartMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startMinute');
    });
  }

  QueryBuilder<DayType, DayType, QDistinct> distinctByTextColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'textColor');
    });
  }
}

extension DayTypeQueryProperty
    on QueryBuilder<DayType, DayType, QQueryProperty> {
  QueryBuilder<DayType, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DayType, int, QQueryOperations> backgroundColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backgroundColor');
    });
  }

  QueryBuilder<DayType, int?, QQueryOperations> endHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endHour');
    });
  }

  QueryBuilder<DayType, int?, QQueryOperations> endMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endMinute');
    });
  }

  QueryBuilder<DayType, bool, QQueryOperations> isWorkDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isWorkDay');
    });
  }

  QueryBuilder<DayType, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<DayType, int?, QQueryOperations> startHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startHour');
    });
  }

  QueryBuilder<DayType, int?, QQueryOperations> startMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startMinute');
    });
  }

  QueryBuilder<DayType, int, QQueryOperations> textColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textColor');
    });
  }
}
