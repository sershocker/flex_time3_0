// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingsCollection on Isar {
  IsarCollection<AppSettings> get appSettings => this.collection();
}

const AppSettingsSchema = CollectionSchema(
  name: r'AppSettings',
  id: -5633561779022347008,
  properties: {
    r'colorScheme': PropertySchema(
      id: 0,
      name: r'colorScheme',
      type: IsarType.byte,
      enumMap: _AppSettingscolorSchemeEnumValueMap,
    ),
    r'firstDayOfWeek': PropertySchema(
      id: 1,
      name: r'firstDayOfWeek',
      type: IsarType.byte,
      enumMap: _AppSettingsfirstDayOfWeekEnumValueMap,
    ),
    r'googleSyncEnabled': PropertySchema(
      id: 2,
      name: r'googleSyncEnabled',
      type: IsarType.bool,
    ),
    r'isDarkMode': PropertySchema(
      id: 3,
      name: r'isDarkMode',
      type: IsarType.bool,
    ),
    r'notify1h': PropertySchema(
      id: 4,
      name: r'notify1h',
      type: IsarType.bool,
    ),
    r'notify24h': PropertySchema(
      id: 5,
      name: r'notify24h',
      type: IsarType.bool,
    ),
    r'notifyNow': PropertySchema(
      id: 6,
      name: r'notifyNow',
      type: IsarType.bool,
    )
  },
  estimateSize: _appSettingsEstimateSize,
  serialize: _appSettingsSerialize,
  deserialize: _appSettingsDeserialize,
  deserializeProp: _appSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appSettingsGetId,
  getLinks: _appSettingsGetLinks,
  attach: _appSettingsAttach,
  version: '3.1.0+1',
);

int _appSettingsEstimateSize(
  AppSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _appSettingsSerialize(
  AppSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.colorScheme.index);
  writer.writeByte(offsets[1], object.firstDayOfWeek.index);
  writer.writeBool(offsets[2], object.googleSyncEnabled);
  writer.writeBool(offsets[3], object.isDarkMode);
  writer.writeBool(offsets[4], object.notify1h);
  writer.writeBool(offsets[5], object.notify24h);
  writer.writeBool(offsets[6], object.notifyNow);
}

AppSettings _appSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettings();
  object.colorScheme =
      _AppSettingscolorSchemeValueEnumMap[reader.readByteOrNull(offsets[0])] ??
          ColorSchemeType.red;
  object.firstDayOfWeek = _AppSettingsfirstDayOfWeekValueEnumMap[
          reader.readByteOrNull(offsets[1])] ??
      DayOfWeek.monday;
  object.googleSyncEnabled = reader.readBool(offsets[2]);
  object.id = id;
  object.isDarkMode = reader.readBool(offsets[3]);
  object.notify1h = reader.readBool(offsets[4]);
  object.notify24h = reader.readBool(offsets[5]);
  object.notifyNow = reader.readBool(offsets[6]);
  return object;
}

P _appSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_AppSettingscolorSchemeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ColorSchemeType.red) as P;
    case 1:
      return (_AppSettingsfirstDayOfWeekValueEnumMap[
              reader.readByteOrNull(offset)] ??
          DayOfWeek.monday) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AppSettingscolorSchemeEnumValueMap = {
  'red': 0,
  'yellow': 1,
  'green': 2,
  'blue': 3,
};
const _AppSettingscolorSchemeValueEnumMap = {
  0: ColorSchemeType.red,
  1: ColorSchemeType.yellow,
  2: ColorSchemeType.green,
  3: ColorSchemeType.blue,
};
const _AppSettingsfirstDayOfWeekEnumValueMap = {
  'monday': 0,
  'sunday': 1,
};
const _AppSettingsfirstDayOfWeekValueEnumMap = {
  0: DayOfWeek.monday,
  1: DayOfWeek.sunday,
};

Id _appSettingsGetId(AppSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingsGetLinks(AppSettings object) {
  return [];
}

void _appSettingsAttach(
    IsarCollection<dynamic> col, Id id, AppSettings object) {
  object.id = id;
}

extension AppSettingsQueryWhereSort
    on QueryBuilder<AppSettings, AppSettings, QWhere> {
  QueryBuilder<AppSettings, AppSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingsQueryWhere
    on QueryBuilder<AppSettings, AppSettings, QWhereClause> {
  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idBetween(
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

extension AppSettingsQueryFilter
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {
  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      colorSchemeEqualTo(ColorSchemeType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorScheme',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      colorSchemeGreaterThan(
    ColorSchemeType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorScheme',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      colorSchemeLessThan(
    ColorSchemeType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorScheme',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      colorSchemeBetween(
    ColorSchemeType lower,
    ColorSchemeType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorScheme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      firstDayOfWeekEqualTo(DayOfWeek value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstDayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      firstDayOfWeekGreaterThan(
    DayOfWeek value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstDayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      firstDayOfWeekLessThan(
    DayOfWeek value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstDayOfWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      firstDayOfWeekBetween(
    DayOfWeek lower,
    DayOfWeek upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstDayOfWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      googleSyncEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'googleSyncEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      isDarkModeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDarkMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> notify1hEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notify1h',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      notify24hEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notify24h',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      notifyNowEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notifyNow',
        value: value,
      ));
    });
  }
}

extension AppSettingsQueryObject
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {}

extension AppSettingsQueryLinks
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {}

extension AppSettingsQuerySortBy
    on QueryBuilder<AppSettings, AppSettings, QSortBy> {
  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByColorScheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorScheme', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByColorSchemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorScheme', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByFirstDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByFirstDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByGoogleSyncEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleSyncEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByGoogleSyncEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleSyncEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByIsDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDarkMode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByIsDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDarkMode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByNotify1h() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notify1h', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByNotify1hDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notify1h', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByNotify24h() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notify24h', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByNotify24hDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notify24h', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByNotifyNow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyNow', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByNotifyNowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyNow', Sort.desc);
    });
  }
}

extension AppSettingsQuerySortThenBy
    on QueryBuilder<AppSettings, AppSettings, QSortThenBy> {
  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByColorScheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorScheme', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByColorSchemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorScheme', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByFirstDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByFirstDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByGoogleSyncEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleSyncEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByGoogleSyncEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'googleSyncEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIsDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDarkMode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIsDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDarkMode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByNotify1h() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notify1h', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByNotify1hDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notify1h', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByNotify24h() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notify24h', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByNotify24hDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notify24h', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByNotifyNow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyNow', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByNotifyNowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notifyNow', Sort.desc);
    });
  }
}

extension AppSettingsQueryWhereDistinct
    on QueryBuilder<AppSettings, AppSettings, QDistinct> {
  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByColorScheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorScheme');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByFirstDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstDayOfWeek');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByGoogleSyncEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'googleSyncEnabled');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByIsDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDarkMode');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByNotify1h() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notify1h');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByNotify24h() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notify24h');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByNotifyNow() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notifyNow');
    });
  }
}

extension AppSettingsQueryProperty
    on QueryBuilder<AppSettings, AppSettings, QQueryProperty> {
  QueryBuilder<AppSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSettings, ColorSchemeType, QQueryOperations>
      colorSchemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorScheme');
    });
  }

  QueryBuilder<AppSettings, DayOfWeek, QQueryOperations>
      firstDayOfWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstDayOfWeek');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      googleSyncEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'googleSyncEnabled');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations> isDarkModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDarkMode');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations> notify1hProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notify1h');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations> notify24hProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notify24h');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations> notifyNowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notifyNow');
    });
  }
}
