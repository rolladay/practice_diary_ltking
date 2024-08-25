// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get uid => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get photoUrl => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdTime => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get lastSignedIn => throw _privateConstructorUsedError;
  double get totalSpend => throw _privateConstructorUsedError;
  double get totalPrize => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  double? get winningRate => throw _privateConstructorUsedError;
  int? get rank => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {String uid,
      String displayName,
      String photoUrl,
      @TimestampConverter() DateTime createdTime,
      @TimestampConverter() DateTime lastSignedIn,
      double totalSpend,
      double totalPrize,
      String email,
      double? winningRate,
      int? rank});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? displayName = null,
    Object? photoUrl = null,
    Object? createdTime = null,
    Object? lastSignedIn = null,
    Object? totalSpend = null,
    Object? totalPrize = null,
    Object? email = null,
    Object? winningRate = freezed,
    Object? rank = freezed,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: null == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdTime: null == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSignedIn: null == lastSignedIn
          ? _value.lastSignedIn
          : lastSignedIn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalSpend: null == totalSpend
          ? _value.totalSpend
          : totalSpend // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrize: null == totalPrize
          ? _value.totalPrize
          : totalPrize // ignore: cast_nullable_to_non_nullable
              as double,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      winningRate: freezed == winningRate
          ? _value.winningRate
          : winningRate // ignore: cast_nullable_to_non_nullable
              as double?,
      rank: freezed == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String displayName,
      String photoUrl,
      @TimestampConverter() DateTime createdTime,
      @TimestampConverter() DateTime lastSignedIn,
      double totalSpend,
      double totalPrize,
      String email,
      double? winningRate,
      int? rank});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? displayName = null,
    Object? photoUrl = null,
    Object? createdTime = null,
    Object? lastSignedIn = null,
    Object? totalSpend = null,
    Object? totalPrize = null,
    Object? email = null,
    Object? winningRate = freezed,
    Object? rank = freezed,
  }) {
    return _then(_$UserImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: null == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdTime: null == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastSignedIn: null == lastSignedIn
          ? _value.lastSignedIn
          : lastSignedIn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalSpend: null == totalSpend
          ? _value.totalSpend
          : totalSpend // ignore: cast_nullable_to_non_nullable
              as double,
      totalPrize: null == totalPrize
          ? _value.totalPrize
          : totalPrize // ignore: cast_nullable_to_non_nullable
              as double,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      winningRate: freezed == winningRate
          ? _value.winningRate
          : winningRate // ignore: cast_nullable_to_non_nullable
              as double?,
      rank: freezed == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  _$UserImpl(
      {required this.uid,
      required this.displayName,
      required this.photoUrl,
      @TimestampConverter() required this.createdTime,
      @TimestampConverter() required this.lastSignedIn,
      required this.totalSpend,
      required this.totalPrize,
      required this.email,
      this.winningRate,
      this.rank});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String uid;
  @override
  final String displayName;
  @override
  final String photoUrl;
  @override
  @TimestampConverter()
  final DateTime createdTime;
  @override
  @TimestampConverter()
  final DateTime lastSignedIn;
  @override
  final double totalSpend;
  @override
  final double totalPrize;
  @override
  final String email;
  @override
  final double? winningRate;
  @override
  final int? rank;

  @override
  String toString() {
    return 'UserModel(uid: $uid, displayName: $displayName, photoUrl: $photoUrl, createdTime: $createdTime, lastSignedIn: $lastSignedIn, totalSpend: $totalSpend, totalPrize: $totalPrize, email: $email, winningRate: $winningRate, rank: $rank)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.lastSignedIn, lastSignedIn) ||
                other.lastSignedIn == lastSignedIn) &&
            (identical(other.totalSpend, totalSpend) ||
                other.totalSpend == totalSpend) &&
            (identical(other.totalPrize, totalPrize) ||
                other.totalPrize == totalPrize) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.winningRate, winningRate) ||
                other.winningRate == winningRate) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      displayName,
      photoUrl,
      createdTime,
      lastSignedIn,
      totalSpend,
      totalPrize,
      email,
      winningRate,
      rank);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements UserModel {
  factory _User(
      {required final String uid,
      required final String displayName,
      required final String photoUrl,
      @TimestampConverter() required final DateTime createdTime,
      @TimestampConverter() required final DateTime lastSignedIn,
      required final double totalSpend,
      required final double totalPrize,
      required final String email,
      final double? winningRate,
      final int? rank}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get uid;
  @override
  String get displayName;
  @override
  String get photoUrl;
  @override
  @TimestampConverter()
  DateTime get createdTime;
  @override
  @TimestampConverter()
  DateTime get lastSignedIn;
  @override
  double get totalSpend;
  @override
  double get totalPrize;
  @override
  String get email;
  @override
  double? get winningRate;
  @override
  int? get rank;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
