// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillModel {
  String? get id;
  BillType get type;
  int get amount;
  int? get value;

  /// Create a copy of BillModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BillModelCopyWith<BillModel> get copyWith =>
      _$BillModelCopyWithImpl<BillModel>(this as BillModel, _$identity);

  /// Serializes this BillModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BillModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, amount, value);

  @override
  String toString() {
    return 'BillModel(id: $id, type: $type, amount: $amount, value: $value)';
  }
}

/// @nodoc
abstract mixin class $BillModelCopyWith<$Res> {
  factory $BillModelCopyWith(BillModel value, $Res Function(BillModel) _then) =
      _$BillModelCopyWithImpl;
  @useResult
  $Res call({String? id, BillType type, int amount, int? value});
}

/// @nodoc
class _$BillModelCopyWithImpl<$Res> implements $BillModelCopyWith<$Res> {
  _$BillModelCopyWithImpl(this._self, this._then);

  final BillModel _self;
  final $Res Function(BillModel) _then;

  /// Create a copy of BillModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? type = null,
    Object? amount = null,
    Object? value = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as BillType,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _BillModel implements BillModel {
  const _BillModel(
      {this.id, required this.type, required this.amount, this.value});
  factory _BillModel.fromJson(Map<String, dynamic> json) =>
      _$BillModelFromJson(json);

  @override
  final String? id;
  @override
  final BillType type;
  @override
  final int amount;
  @override
  final int? value;

  /// Create a copy of BillModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BillModelCopyWith<_BillModel> get copyWith =>
      __$BillModelCopyWithImpl<_BillModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BillModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BillModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, amount, value);

  @override
  String toString() {
    return 'BillModel(id: $id, type: $type, amount: $amount, value: $value)';
  }
}

/// @nodoc
abstract mixin class _$BillModelCopyWith<$Res>
    implements $BillModelCopyWith<$Res> {
  factory _$BillModelCopyWith(
          _BillModel value, $Res Function(_BillModel) _then) =
      __$BillModelCopyWithImpl;
  @override
  @useResult
  $Res call({String? id, BillType type, int amount, int? value});
}

/// @nodoc
class __$BillModelCopyWithImpl<$Res> implements _$BillModelCopyWith<$Res> {
  __$BillModelCopyWithImpl(this._self, this._then);

  final _BillModel _self;
  final $Res Function(_BillModel) _then;

  /// Create a copy of BillModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? type = null,
    Object? amount = null,
    Object? value = freezed,
  }) {
    return _then(_BillModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as BillType,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
