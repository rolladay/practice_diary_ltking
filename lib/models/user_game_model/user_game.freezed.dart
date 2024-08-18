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
  return _Game.fromJson(json);
}

/// @nodoc
mixin _$UserGame {
  int get roundNo => throw _privateConstructorUsedError;
  Set<int> get selectedDrwNos => throw _privateConstructorUsedError;
  String get playerUid => throw _privateConstructorUsedError;
  String? get result => throw _privateConstructorUsedError;
  Set<int>? get winningNos => throw _privateConstructorUsedError;
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
      {int roundNo,
      Set<int> selectedDrwNos,
      String playerUid,
      String? result,
      Set<int>? winningNos,
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
    Object? roundNo = null,
    Object? selectedDrwNos = null,
    Object? playerUid = null,
    Object? result = freezed,
    Object? winningNos = freezed,
    Object? matchingCount = freezed,
    Object? bonusNo = freezed,
  }) {
    return _then(_value.copyWith(
      roundNo: null == roundNo
          ? _value.roundNo
          : roundNo // ignore: cast_nullable_to_non_nullable
              as int,
      selectedDrwNos: null == selectedDrwNos
          ? _value.selectedDrwNos
          : selectedDrwNos // ignore: cast_nullable_to_non_nullable
              as Set<int>,
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
              as Set<int>?,
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
abstract class _$$GameImplCopyWith<$Res> implements $UserGameCopyWith<$Res> {
  factory _$$GameImplCopyWith(
          _$GameImpl value, $Res Function(_$GameImpl) then) =
      __$$GameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int roundNo,
      Set<int> selectedDrwNos,
      String playerUid,
      String? result,
      Set<int>? winningNos,
      int? matchingCount,
      int? bonusNo});
}

/// @nodoc
class __$$GameImplCopyWithImpl<$Res>
    extends _$UserGameCopyWithImpl<$Res, _$GameImpl>
    implements _$$GameImplCopyWith<$Res> {
  __$$GameImplCopyWithImpl(_$GameImpl _value, $Res Function(_$GameImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roundNo = null,
    Object? selectedDrwNos = null,
    Object? playerUid = null,
    Object? result = freezed,
    Object? winningNos = freezed,
    Object? matchingCount = freezed,
    Object? bonusNo = freezed,
  }) {
    return _then(_$GameImpl(
      roundNo: null == roundNo
          ? _value.roundNo
          : roundNo // ignore: cast_nullable_to_non_nullable
              as int,
      selectedDrwNos: null == selectedDrwNos
          ? _value._selectedDrwNos
          : selectedDrwNos // ignore: cast_nullable_to_non_nullable
              as Set<int>,
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
              as Set<int>?,
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
class _$GameImpl implements _Game {
  _$GameImpl(
      {required this.roundNo,
      required final Set<int> selectedDrwNos,
      required this.playerUid,
      this.result,
      final Set<int>? winningNos,
      this.matchingCount,
      this.bonusNo})
      : _selectedDrwNos = selectedDrwNos,
        _winningNos = winningNos;

  factory _$GameImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameImplFromJson(json);

  @override
  final int roundNo;
  final Set<int> _selectedDrwNos;
  @override
  Set<int> get selectedDrwNos {
    if (_selectedDrwNos is EqualUnmodifiableSetView) return _selectedDrwNos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedDrwNos);
  }

  @override
  final String playerUid;
  @override
  final String? result;
  final Set<int>? _winningNos;
  @override
  Set<int>? get winningNos {
    final value = _winningNos;
    if (value == null) return null;
    if (_winningNos is EqualUnmodifiableSetView) return _winningNos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(value);
  }

  @override
  final int? matchingCount;
  @override
  final int? bonusNo;

  @override
  String toString() {
    return 'UserGame(roundNo: $roundNo, selectedDrwNos: $selectedDrwNos, playerUid: $playerUid, result: $result, winningNos: $winningNos, matchingCount: $matchingCount, bonusNo: $bonusNo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameImpl &&
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
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      __$$GameImplCopyWithImpl<_$GameImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameImplToJson(
      this,
    );
  }
}

abstract class _Game implements UserGame {
  factory _Game(
      {required final int roundNo,
      required final Set<int> selectedDrwNos,
      required final String playerUid,
      final String? result,
      final Set<int>? winningNos,
      final int? matchingCount,
      final int? bonusNo}) = _$GameImpl;

  factory _Game.fromJson(Map<String, dynamic> json) = _$GameImpl.fromJson;

  @override
  int get roundNo;
  @override
  Set<int> get selectedDrwNos;
  @override
  String get playerUid;
  @override
  String? get result;
  @override
  Set<int>? get winningNos;
  @override
  int? get matchingCount;
  @override
  int? get bonusNo;
  @override
  @JsonKey(ignore: true)
  _$$GameImplCopyWith<_$GameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
