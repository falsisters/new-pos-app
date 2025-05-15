// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseItemDto {
  String get name;
  double get amount;

  /// Create a copy of ExpenseItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExpenseItemDtoCopyWith<ExpenseItemDto> get copyWith =>
      _$ExpenseItemDtoCopyWithImpl<ExpenseItemDto>(
          this as ExpenseItemDto, _$identity);

  /// Serializes this ExpenseItemDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExpenseItemDto &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, amount);

  @override
  String toString() {
    return 'ExpenseItemDto(name: $name, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class $ExpenseItemDtoCopyWith<$Res> {
  factory $ExpenseItemDtoCopyWith(
          ExpenseItemDto value, $Res Function(ExpenseItemDto) _then) =
      _$ExpenseItemDtoCopyWithImpl;
  @useResult
  $Res call({String name, double amount});
}

/// @nodoc
class _$ExpenseItemDtoCopyWithImpl<$Res>
    implements $ExpenseItemDtoCopyWith<$Res> {
  _$ExpenseItemDtoCopyWithImpl(this._self, this._then);

  final ExpenseItemDto _self;
  final $Res Function(ExpenseItemDto) _then;

  /// Create a copy of ExpenseItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ExpenseItemDto implements ExpenseItemDto {
  const _ExpenseItemDto({required this.name, required this.amount});
  factory _ExpenseItemDto.fromJson(Map<String, dynamic> json) =>
      _$ExpenseItemDtoFromJson(json);

  @override
  final String name;
  @override
  final double amount;

  /// Create a copy of ExpenseItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExpenseItemDtoCopyWith<_ExpenseItemDto> get copyWith =>
      __$ExpenseItemDtoCopyWithImpl<_ExpenseItemDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExpenseItemDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExpenseItemDto &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, amount);

  @override
  String toString() {
    return 'ExpenseItemDto(name: $name, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class _$ExpenseItemDtoCopyWith<$Res>
    implements $ExpenseItemDtoCopyWith<$Res> {
  factory _$ExpenseItemDtoCopyWith(
          _ExpenseItemDto value, $Res Function(_ExpenseItemDto) _then) =
      __$ExpenseItemDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String name, double amount});
}

/// @nodoc
class __$ExpenseItemDtoCopyWithImpl<$Res>
    implements _$ExpenseItemDtoCopyWith<$Res> {
  __$ExpenseItemDtoCopyWithImpl(this._self, this._then);

  final _ExpenseItemDto _self;
  final $Res Function(_ExpenseItemDto) _then;

  /// Create a copy of ExpenseItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? amount = null,
  }) {
    return _then(_ExpenseItemDto(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
