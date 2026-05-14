// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_template.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetShiftTemplateCollection on Isar {
  IsarCollection<ShiftTemplate> get shiftTemplates => this.collection();
}

const ShiftTemplateSchema = CollectionSchema(
  name: r'ShiftTemplate',
  id: 3831798502749280993,
  properties: {
    r'dayTypeIds': PropertySchema(
      id: 0,
      name: r'dayTypeIds',
      type: IsarType.longList,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _shiftTemplateEstimateSize,
  serialize: _shiftTemplateSerialize,
  deserialize: _shiftTemplateDeserialize,
  deserializeProp: _shiftTemplateDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _shiftTemplateGetId,
  getLinks: _shiftTemplateGetLinks,
  attach: _shiftTemplateAttach,
  version: '3.1.0+1',
);

int _shiftTemplateEstimateSize(
  ShiftTemplate object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dayTypeIds.length * 8;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _shiftTemplateSerialize(
  ShiftTemplate object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.dayTypeIds);
  writer.writeString(offsets[1], object.name);
}

ShiftTemplate _shiftTemplateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ShiftTemplate();
  object.dayTypeIds = reader.readLongList(offsets[0]) ?? [];
  object.id = id;
  object.name = reader.readString(offsets[1]);
  return object;
}

P _shiftTemplateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _shiftTemplateGetId(ShiftTemplate object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _shiftTemplateGetLinks(ShiftTemplate object) {
  return [];
}

void _shiftTemplateAttach(
    IsarCollection<dynamic> col, Id id, ShiftTemplate object) {
  object.id = id;
}

extension ShiftTemplateQueryWhereSort
    on QueryBuilder<ShiftTemplate, ShiftTemplate, QWhere> {
  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ShiftTemplateQueryWhere
    on QueryBuilder<ShiftTemplate, ShiftTemplate, QWhereClause> {
  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ShiftTemplateQueryFilter
    on QueryBuilder<ShiftTemplate, ShiftTemplate, QFilterCondition> {
  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      dayTypeIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayTypeIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      dayTypeIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayTypeIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      dayTypeIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayTypeIds',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      dayTypeIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayTypeIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      dayTypeIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dayTypeIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      dayTypeIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dayTypeIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      dayTypeIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dayTypeIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      dayTypeIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dayTypeIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      dayTypeIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dayTypeIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      dayTypeIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'dayTypeIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension ShiftTemplateQueryObject
    on QueryBuilder<ShiftTemplate, ShiftTemplate, QFilterCondition> {}

extension ShiftTemplateQueryLinks
    on QueryBuilder<ShiftTemplate, ShiftTemplate, QFilterCondition> {}

extension ShiftTemplateQuerySortBy
    on QueryBuilder<ShiftTemplate, ShiftTemplate, QSortBy> {
  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension ShiftTemplateQuerySortThenBy
    on QueryBuilder<ShiftTemplate, ShiftTemplate, QSortThenBy> {
  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension ShiftTemplateQueryWhereDistinct
    on QueryBuilder<ShiftTemplate, ShiftTemplate, QDistinct> {
  QueryBuilder<ShiftTemplate, ShiftTemplate, QDistinct> distinctByDayTypeIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayTypeIds');
    });
  }

  QueryBuilder<ShiftTemplate, ShiftTemplate, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension ShiftTemplateQueryProperty
    on QueryBuilder<ShiftTemplate, ShiftTemplate, QQueryProperty> {
  QueryBuilder<ShiftTemplate, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ShiftTemplate, List<int>, QQueryOperations>
      dayTypeIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayTypeIds');
    });
  }

  QueryBuilder<ShiftTemplate, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
