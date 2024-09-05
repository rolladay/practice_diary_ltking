// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lotto_result.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLottoResultCollection on Isar {
  IsarCollection<LottoResult> get lottoResults => this.collection();
}

const LottoResultSchema = CollectionSchema(
  name: r'LottoResult',
  id: -8501776532441643669,
  properties: {
    r'bonusNumber': PropertySchema(
      id: 0,
      name: r'bonusNumber',
      type: IsarType.long,
    ),
    r'drawDate': PropertySchema(
      id: 1,
      name: r'drawDate',
      type: IsarType.dateTime,
    ),
    r'formattedYMDDrawDate': PropertySchema(
      id: 2,
      name: r'formattedYMDDrawDate',
      type: IsarType.string,
    ),
    r'nextWeekDrawDate': PropertySchema(
      id: 3,
      name: r'nextWeekDrawDate',
      type: IsarType.string,
    ),
    r'prizeAmounts': PropertySchema(
      id: 4,
      name: r'prizeAmounts',
      type: IsarType.string,
    ),
    r'prizeAmounts2': PropertySchema(
      id: 5,
      name: r'prizeAmounts2',
      type: IsarType.string,
    ),
    r'prizeAmounts3': PropertySchema(
      id: 6,
      name: r'prizeAmounts3',
      type: IsarType.string,
    ),
    r'roundNumber': PropertySchema(
      id: 7,
      name: r'roundNumber',
      type: IsarType.long,
    ),
    r'winners': PropertySchema(
      id: 8,
      name: r'winners',
      type: IsarType.string,
    ),
    r'winningNumbers': PropertySchema(
      id: 9,
      name: r'winningNumbers',
      type: IsarType.longList,
    )
  },
  estimateSize: _lottoResultEstimateSize,
  serialize: _lottoResultSerialize,
  deserialize: _lottoResultDeserialize,
  deserializeProp: _lottoResultDeserializeProp,
  idName: r'id',
  indexes: {
    r'roundNumber': IndexSchema(
      id: -6162831749858355618,
      name: r'roundNumber',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'roundNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _lottoResultGetId,
  getLinks: _lottoResultGetLinks,
  attach: _lottoResultAttach,
  version: '3.1.0+1',
);

int _lottoResultEstimateSize(
  LottoResult object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.formattedYMDDrawDate.length * 3;
  bytesCount += 3 + object.nextWeekDrawDate.length * 3;
  bytesCount += 3 + object.prizeAmounts.length * 3;
  bytesCount += 3 + object.prizeAmounts2.length * 3;
  bytesCount += 3 + object.prizeAmounts3.length * 3;
  bytesCount += 3 + object.winners.length * 3;
  bytesCount += 3 + object.winningNumbers.length * 8;
  return bytesCount;
}

void _lottoResultSerialize(
  LottoResult object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bonusNumber);
  writer.writeDateTime(offsets[1], object.drawDate);
  writer.writeString(offsets[2], object.formattedYMDDrawDate);
  writer.writeString(offsets[3], object.nextWeekDrawDate);
  writer.writeString(offsets[4], object.prizeAmounts);
  writer.writeString(offsets[5], object.prizeAmounts2);
  writer.writeString(offsets[6], object.prizeAmounts3);
  writer.writeLong(offsets[7], object.roundNumber);
  writer.writeString(offsets[8], object.winners);
  writer.writeLongList(offsets[9], object.winningNumbers);
}

LottoResult _lottoResultDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LottoResult(
    bonusNumber: reader.readLong(offsets[0]),
    drawDate: reader.readDateTime(offsets[1]),
    prizeAmounts: reader.readString(offsets[4]),
    prizeAmounts2: reader.readString(offsets[5]),
    prizeAmounts3: reader.readString(offsets[6]),
    roundNumber: reader.readLong(offsets[7]),
    winners: reader.readString(offsets[8]),
    winningNumbers: reader.readLongList(offsets[9]) ?? [],
  );
  object.id = id;
  return object;
}

P _lottoResultDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLongList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _lottoResultGetId(LottoResult object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _lottoResultGetLinks(LottoResult object) {
  return [];
}

void _lottoResultAttach(
    IsarCollection<dynamic> col, Id id, LottoResult object) {
  object.id = id;
}

extension LottoResultByIndex on IsarCollection<LottoResult> {
  Future<LottoResult?> getByRoundNumber(int roundNumber) {
    return getByIndex(r'roundNumber', [roundNumber]);
  }

  LottoResult? getByRoundNumberSync(int roundNumber) {
    return getByIndexSync(r'roundNumber', [roundNumber]);
  }

  Future<bool> deleteByRoundNumber(int roundNumber) {
    return deleteByIndex(r'roundNumber', [roundNumber]);
  }

  bool deleteByRoundNumberSync(int roundNumber) {
    return deleteByIndexSync(r'roundNumber', [roundNumber]);
  }

  Future<List<LottoResult?>> getAllByRoundNumber(List<int> roundNumberValues) {
    final values = roundNumberValues.map((e) => [e]).toList();
    return getAllByIndex(r'roundNumber', values);
  }

  List<LottoResult?> getAllByRoundNumberSync(List<int> roundNumberValues) {
    final values = roundNumberValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'roundNumber', values);
  }

  Future<int> deleteAllByRoundNumber(List<int> roundNumberValues) {
    final values = roundNumberValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'roundNumber', values);
  }

  int deleteAllByRoundNumberSync(List<int> roundNumberValues) {
    final values = roundNumberValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'roundNumber', values);
  }

  Future<Id> putByRoundNumber(LottoResult object) {
    return putByIndex(r'roundNumber', object);
  }

  Id putByRoundNumberSync(LottoResult object, {bool saveLinks = true}) {
    return putByIndexSync(r'roundNumber', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRoundNumber(List<LottoResult> objects) {
    return putAllByIndex(r'roundNumber', objects);
  }

  List<Id> putAllByRoundNumberSync(List<LottoResult> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'roundNumber', objects, saveLinks: saveLinks);
  }
}

extension LottoResultQueryWhereSort
    on QueryBuilder<LottoResult, LottoResult, QWhere> {
  QueryBuilder<LottoResult, LottoResult, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterWhere> anyRoundNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'roundNumber'),
      );
    });
  }
}

extension LottoResultQueryWhere
    on QueryBuilder<LottoResult, LottoResult, QWhereClause> {
  QueryBuilder<LottoResult, LottoResult, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<LottoResult, LottoResult, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterWhereClause> idBetween(
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

  QueryBuilder<LottoResult, LottoResult, QAfterWhereClause> roundNumberEqualTo(
      int roundNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'roundNumber',
        value: [roundNumber],
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterWhereClause>
      roundNumberNotEqualTo(int roundNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'roundNumber',
              lower: [],
              upper: [roundNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'roundNumber',
              lower: [roundNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'roundNumber',
              lower: [roundNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'roundNumber',
              lower: [],
              upper: [roundNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterWhereClause>
      roundNumberGreaterThan(
    int roundNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'roundNumber',
        lower: [roundNumber],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterWhereClause> roundNumberLessThan(
    int roundNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'roundNumber',
        lower: [],
        upper: [roundNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterWhereClause> roundNumberBetween(
    int lowerRoundNumber,
    int upperRoundNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'roundNumber',
        lower: [lowerRoundNumber],
        includeLower: includeLower,
        upper: [upperRoundNumber],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LottoResultQueryFilter
    on QueryBuilder<LottoResult, LottoResult, QFilterCondition> {
  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      bonusNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bonusNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      bonusNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bonusNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      bonusNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bonusNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      bonusNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bonusNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition> drawDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'drawDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      drawDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'drawDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      drawDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'drawDate',
        value: value,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition> drawDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'drawDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      formattedYMDDrawDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formattedYMDDrawDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      formattedYMDDrawDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'formattedYMDDrawDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      formattedYMDDrawDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'formattedYMDDrawDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      formattedYMDDrawDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'formattedYMDDrawDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      formattedYMDDrawDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'formattedYMDDrawDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      formattedYMDDrawDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'formattedYMDDrawDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      formattedYMDDrawDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'formattedYMDDrawDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      formattedYMDDrawDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'formattedYMDDrawDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      formattedYMDDrawDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'formattedYMDDrawDate',
        value: '',
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      formattedYMDDrawDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'formattedYMDDrawDate',
        value: '',
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      nextWeekDrawDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextWeekDrawDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      nextWeekDrawDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextWeekDrawDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      nextWeekDrawDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextWeekDrawDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      nextWeekDrawDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextWeekDrawDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      nextWeekDrawDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nextWeekDrawDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      nextWeekDrawDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nextWeekDrawDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      nextWeekDrawDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nextWeekDrawDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      nextWeekDrawDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nextWeekDrawDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      nextWeekDrawDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextWeekDrawDate',
        value: '',
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      nextWeekDrawDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nextWeekDrawDate',
        value: '',
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmountsEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prizeAmounts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmountsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prizeAmounts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmountsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prizeAmounts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmountsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prizeAmounts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmountsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'prizeAmounts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmountsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'prizeAmounts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmountsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'prizeAmounts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmountsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'prizeAmounts',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmountsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prizeAmounts',
        value: '',
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmountsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'prizeAmounts',
        value: '',
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts2EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prizeAmounts2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts2GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prizeAmounts2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts2LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prizeAmounts2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts2Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prizeAmounts2',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts2StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'prizeAmounts2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts2EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'prizeAmounts2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts2Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'prizeAmounts2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts2Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'prizeAmounts2',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts2IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prizeAmounts2',
        value: '',
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts2IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'prizeAmounts2',
        value: '',
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts3EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prizeAmounts3',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts3GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prizeAmounts3',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts3LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prizeAmounts3',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts3Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prizeAmounts3',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts3StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'prizeAmounts3',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts3EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'prizeAmounts3',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts3Contains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'prizeAmounts3',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts3Matches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'prizeAmounts3',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts3IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prizeAmounts3',
        value: '',
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      prizeAmounts3IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'prizeAmounts3',
        value: '',
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      roundNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roundNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      roundNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'roundNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      roundNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'roundNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      roundNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'roundNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition> winnersEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'winners',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winnersGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'winners',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition> winnersLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'winners',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition> winnersBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'winners',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winnersStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'winners',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition> winnersEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'winners',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition> winnersContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'winners',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition> winnersMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'winners',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winnersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'winners',
        value: '',
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winnersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'winners',
        value: '',
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winningNumbersElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'winningNumbers',
        value: value,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winningNumbersElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'winningNumbers',
        value: value,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winningNumbersElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'winningNumbers',
        value: value,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winningNumbersElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'winningNumbers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winningNumbersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'winningNumbers',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winningNumbersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'winningNumbers',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winningNumbersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'winningNumbers',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winningNumbersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'winningNumbers',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winningNumbersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'winningNumbers',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterFilterCondition>
      winningNumbersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'winningNumbers',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension LottoResultQueryObject
    on QueryBuilder<LottoResult, LottoResult, QFilterCondition> {}

extension LottoResultQueryLinks
    on QueryBuilder<LottoResult, LottoResult, QFilterCondition> {}

extension LottoResultQuerySortBy
    on QueryBuilder<LottoResult, LottoResult, QSortBy> {
  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> sortByBonusNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bonusNumber', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> sortByBonusNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bonusNumber', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> sortByDrawDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawDate', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> sortByDrawDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawDate', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      sortByFormattedYMDDrawDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedYMDDrawDate', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      sortByFormattedYMDDrawDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedYMDDrawDate', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      sortByNextWeekDrawDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextWeekDrawDate', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      sortByNextWeekDrawDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextWeekDrawDate', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> sortByPrizeAmounts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prizeAmounts', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      sortByPrizeAmountsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prizeAmounts', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> sortByPrizeAmounts2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prizeAmounts2', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      sortByPrizeAmounts2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prizeAmounts2', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> sortByPrizeAmounts3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prizeAmounts3', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      sortByPrizeAmounts3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prizeAmounts3', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> sortByRoundNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roundNumber', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> sortByRoundNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roundNumber', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> sortByWinners() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winners', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> sortByWinnersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winners', Sort.desc);
    });
  }
}

extension LottoResultQuerySortThenBy
    on QueryBuilder<LottoResult, LottoResult, QSortThenBy> {
  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> thenByBonusNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bonusNumber', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> thenByBonusNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bonusNumber', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> thenByDrawDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawDate', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> thenByDrawDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'drawDate', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      thenByFormattedYMDDrawDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedYMDDrawDate', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      thenByFormattedYMDDrawDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'formattedYMDDrawDate', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      thenByNextWeekDrawDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextWeekDrawDate', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      thenByNextWeekDrawDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextWeekDrawDate', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> thenByPrizeAmounts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prizeAmounts', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      thenByPrizeAmountsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prizeAmounts', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> thenByPrizeAmounts2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prizeAmounts2', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      thenByPrizeAmounts2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prizeAmounts2', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> thenByPrizeAmounts3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prizeAmounts3', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy>
      thenByPrizeAmounts3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prizeAmounts3', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> thenByRoundNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roundNumber', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> thenByRoundNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roundNumber', Sort.desc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> thenByWinners() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winners', Sort.asc);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QAfterSortBy> thenByWinnersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'winners', Sort.desc);
    });
  }
}

extension LottoResultQueryWhereDistinct
    on QueryBuilder<LottoResult, LottoResult, QDistinct> {
  QueryBuilder<LottoResult, LottoResult, QDistinct> distinctByBonusNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bonusNumber');
    });
  }

  QueryBuilder<LottoResult, LottoResult, QDistinct> distinctByDrawDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'drawDate');
    });
  }

  QueryBuilder<LottoResult, LottoResult, QDistinct>
      distinctByFormattedYMDDrawDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'formattedYMDDrawDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QDistinct> distinctByNextWeekDrawDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextWeekDrawDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QDistinct> distinctByPrizeAmounts(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prizeAmounts', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QDistinct> distinctByPrizeAmounts2(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prizeAmounts2',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QDistinct> distinctByPrizeAmounts3(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prizeAmounts3',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QDistinct> distinctByRoundNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'roundNumber');
    });
  }

  QueryBuilder<LottoResult, LottoResult, QDistinct> distinctByWinners(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'winners', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LottoResult, LottoResult, QDistinct> distinctByWinningNumbers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'winningNumbers');
    });
  }
}

extension LottoResultQueryProperty
    on QueryBuilder<LottoResult, LottoResult, QQueryProperty> {
  QueryBuilder<LottoResult, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LottoResult, int, QQueryOperations> bonusNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bonusNumber');
    });
  }

  QueryBuilder<LottoResult, DateTime, QQueryOperations> drawDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'drawDate');
    });
  }

  QueryBuilder<LottoResult, String, QQueryOperations>
      formattedYMDDrawDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'formattedYMDDrawDate');
    });
  }

  QueryBuilder<LottoResult, String, QQueryOperations>
      nextWeekDrawDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextWeekDrawDate');
    });
  }

  QueryBuilder<LottoResult, String, QQueryOperations> prizeAmountsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prizeAmounts');
    });
  }

  QueryBuilder<LottoResult, String, QQueryOperations> prizeAmounts2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prizeAmounts2');
    });
  }

  QueryBuilder<LottoResult, String, QQueryOperations> prizeAmounts3Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prizeAmounts3');
    });
  }

  QueryBuilder<LottoResult, int, QQueryOperations> roundNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'roundNumber');
    });
  }

  QueryBuilder<LottoResult, String, QQueryOperations> winnersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'winners');
    });
  }

  QueryBuilder<LottoResult, List<int>, QQueryOperations>
      winningNumbersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'winningNumbers');
    });
  }
}
