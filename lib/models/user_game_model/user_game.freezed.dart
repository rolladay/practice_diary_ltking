// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserGame _$UserGameFromJson(Map<String, dynamic> json) {
  return _UserGame.fromJson(json);
}

/// @nodoc
mixin _$UserGame {
  String get gameId => throw _privateConstructorUsedError; // 각 게임에 고유 ID 부여
  int get roundNo => throw _privateConstructorUsedError;
  List<int> get selectedDrwNos => throw _privateConstructorUsedError;
  String get playerUid => throw _privateConstructorUsedError;
  String? get result => throw _privateConstructorUsedError;
  List<int>? get winningNos => throw _privateConstructorUsedError;
  int? get matchingCount => throw _privateConstructorUsedError;
  int? get bonusNo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserGameCopyWith<UserGame> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserGameCopyWith<$Res> {
  factory $UserGameCopyWith(UserGame value, $Res Function(UserGame) then) =
      _$UserGameCopyWithImpl<$Res, UserGame>;
  @useResult
  $Res call(
      {String gameId,
      int roundNo,
      List<int> selectedDrwNos,
      String playerUid,
      String? result,
      List<int>? winningNos,
      int? matchingCount,
      int? bonusNo});
}

/// @nodoc
class _$UserGameCopyWithImpl<$Res, $Val extends UserGame>
    implements $UserGameCopyWith<$Res> {
  _$UserGameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? roundNo = null,
    Object? selectedDrwNos = null,
    Object? playerUid = null,
    Object? result = freezed,
    Object? winningNos = freezed,
    Object? matchingCount = freezed,
    Object? bonusNo = freezed,
  }) {
    return _then(_value.copyWith(
      gameId: null == gameId
          ? _value.gameId
          : gameId // ignore: cast_nullable_to_non_nullable
              as String,
      roundNo: null == roundNo
          ? _value.roundNo
          : roundNo // ignore: cast_nullable_to_non_nullable
              as int,
      selectedDrwNos: null == selectedDrwNos
          ? _value.selectedDrwNos
          : selectedDrwNos // ignore: cast_nullable_to_non_nullable
              as List<int>,
      playerUid: null == playerUid
          ? _value.playerUid
          : playerUid // ignore: cast_nullable_to_non_nullable
              as String,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      winningNos: freezed == winningNos
          ? _value.winningNos
          : winningNos // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      matchingCount: freezed == matchingCount
          ? _value.matchingCount
          : matchingCount // ignore: cast_nullable_to_non_nullable
              as int?,
      bonusNo: freezed == bonusNo
          ? _value.bonusNo
          : bonusNo // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserGameImplCopyWith<$Res>
    implements $UserGameCopyWith<$Res> {
  factory _$$UserGameImplCopyWith(
          _$UserGameImpl value, $Res Function(_$UserGameImpl) then) =
      __$$UserGameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String gameId,
      int roundNo,
      List<int> selectedDrwNos,
      String playerUid,
      String? result,
      List<int>? winningNos,
      int? matchingCount,
      int? bonusNo});
}

/// @nodoc
class __$$UserGameImplCopyWithImpl<$Res>
    extends _$UserGameCopyWithImpl<$Res, _$UserGameImpl>
    implements _$$UserGameImplCopyWith<$Res> {
  __$$UserGameImplCopyWithImpl(
      _$UserGameImpl _value, $Res Function(_$UserGameImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameId = null,
    Object? roundNo = null,
    Object? selectedDrwNos = null,
    Object? playerUid = null,
    Object? result = freezed,
    Object? winningNos = freezed,
    Object? matchingCount = freezed,
    Object? bonusNo = freezed,
  }) {
    return _then(_$UserGameImpl(
      gameId: null == gameId
          ? _value.gameId
          : gameId // ignore: cast_nullable_to_non_nullable
              as String,
      roundNo: null == roundNo
          ? _value.roundNo
          : roundNo // ignore: cast_nullable_to_non_nullable
              as int,
      selectedDrwNos: null == selectedDrwNos
          ? _value._selectedDrwNos
          : selectedDrwNos // ignore: cast_nullable_to_non_nullable
              as List<int>,
      playerUid: null == playerUid
          ? _value.playerUid
          : playerUid // ignore: cast_nullable_to_non_nullable
              as String,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
      winningNos: freezed == winningNos
          ? _value._winningNos
          : winningNos // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      matchingCount: freezed == matchingCount
          ? _value.matchingCount
          : matchingCount // ignore: cast_nullable_to_non_nullable
              as int?,
      bonusNo: freezed == bonusNo
          ? _value.bonusNo
          : bonusNo // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserGameImpl implements _UserGame {
  _$UserGameImpl(
      {required this.gameId,
      required this.roundNo,
      required final List<int> selectedDrwNos,
      required this.playerUid,
      this.result,
      final List<int>? winningNos,
      this.matchingCount,
      this.bonusNo})
      : _selectedDrwNos = selectedDrwNos,
        _winningNos = winningNos;

  factory _$UserGameImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserGameImplFromJson(json);

  @override
  final String gameId;
// 각 게임에 고유 ID 부여
  @override
  final int roundNo;
  final List<int> _selectedDrwNos;
  @override
  List<int> get selectedDrwNos {
    if (_selectedDrwNos is EqualUnmodifiableListView) return _selectedDrwNos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedDrwNos);
  }

  @override
  final String playerUid;
  @override
  final String? result;
  final List<int>? _winningNos;
  @override
  List<int>? get winningNos {
    final value = _winningNos;
    if (value == null) return null;
    if (_winningNos is EqualUnmodifiableListView) return _winningNos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? matchingCount;
  @override
  final int? bonusNo;

  @override
  String toString() {
    return 'UserGame(gameId: $gameId, roundNo: $roundNo, selectedDrwNos: $selectedDrwNos, playerUid: $playerUid, result: $result, winningNos: $winningNos, matchingCount: $matchingCount, bonusNo: $bonusNo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserGameImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.roundNo, roundNo) || other.roundNo == roundNo) &&
            const DeepCollectionEquality()
                .equals(other._selectedDrwNos, _selectedDrwNos) &&
            (identical(other.playerUid, playerUid) ||
                other.playerUid == playerUid) &&
            (identical(other.result, result) || other.result == result) &&
            const DeepCollectionEquality()
                .equals(other._winningNos, _winningNos) &&
            (identical(other.matchingCount, matchingCount) ||
                other.matchingCount == matchingCount) &&
            (identical(other.bonusNo, bonusNo) || other.bonusNo == bonusNo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      gameId,
      roundNo,
      const DeepCollectionEquality().hash(_selectedDrwNos),
      playerUid,
      result,
      const DeepCollectionEquality().hash(_winningNos),
      matchingCount,
      bonusNo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserGameImplCopyWith<_$UserGameImpl> get copyWith =>
      __$$UserGameImplCopyWithImpl<_$UserGameImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserGameImplToJson(
      this,
    );
  }
}

abstract class _UserGame implements UserGame {
  factory _UserGame(
      {required final String gameId,
      required final int roundNo,
      required final List<int> selectedDrwNos,
      required final String playerUid,
      final String? result,
      final List<int>? winningNos,
      final int? matchingCount,
      final int? bonusNo}) = _$UserGameImpl;

  factory _UserGame.fromJson(Map<String, dynamic> json) =
      _$UserGameImpl.fromJson;

  @override
  String get gameId;
  @override // 각 게임에 고유 ID 부여
  int get roundNo;
  @override
  List<int> get selectedDrwNos;
  @override
  String get playerUid;
  @override
  String? get result;
  @override
  List<int>? get winningNos;
  @override
  int? get matchingCount;
  @override
  int? get bonusNo;
  @override
  @JsonKey(ignore: true)
  _$$UserGameImplCopyWith<_$UserGameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
