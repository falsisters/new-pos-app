// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_items.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseItems {
  String get id;
  String get name;
  @DecimalConverter()
  Decimal get amount;
  String get expenseListId;
  String get createdAt;
  String get updatedAt;

  /// Create a copy of ExpenseItems
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExpenseItemsCopyWith<ExpenseItems> get copyWith =>
      _$ExpenseItemsCopyWithImpl<ExpenseItems>(
          this as ExpenseItems, _$identity);

  /// Serializes this ExpenseItems to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExpenseItems &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.expenseListId, expenseListId) ||
                other.expenseListId == expenseListId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, amount, expenseListId, createdAt, updatedAt);

  @override
  String toString() {
    return 'ExpenseItems(id: $id, name: $name, amount: $amount, expenseListId: $expenseListId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ExpenseItemsCopyWith<$Res> {
  factory $ExpenseItemsCopyWith(
          ExpenseItems value, $Res Function(ExpenseItems) _then) =
      _$ExpenseItemsCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      @DecimalConverter() Decimal amount,
      String expenseListId,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class _$ExpenseItemsCopyWithImpl<$Res> implements $ExpenseItemsCopyWith<$Res> {
  _$ExpenseItemsCopyWithImpl(this._self, this._then);

  final ExpenseItems _self;
  final $Res Function(ExpenseItems) _then;

  /// Create a copy of ExpenseItems
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
    Object? expenseListId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      expenseListId: null == expenseListId
          ? _self.expenseListId
          : expenseListId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ExpenseItems implements ExpenseItems {
  const _ExpenseItems(
      {required this.id,
      required this.name,
      @DecimalConverter() required this.amount,
      required this.expenseListId,
      required this.createdAt,
      required this.updatedAt});
  factory _ExpenseItems.fromJson(Map<String, dynamic> json) =>
      _$ExpenseItemsFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @DecimalConverter()
  final Decimal amount;
  @override
  final String expenseListId;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  /// Create a copy of ExpenseItems
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExpenseItemsCopyWith<_ExpenseItems> get copyWith =>
      __$ExpenseItemsCopyWithImpl<_ExpenseItems>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExpenseItemsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExpenseItems &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.expenseListId, expenseListId) ||
                other.expenseListId == expenseListId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, amount, expenseListId, createdAt, updatedAt);

  @override
  String toString() {
    return 'ExpenseItems(id: $id, name: $name, amount: $amount, expenseListId: $expenseListId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$ExpenseItemsCopyWith<$Res>
    implements $ExpenseItemsCopyWith<$Res> {
  factory _$ExpenseItemsCopyWith(
          _ExpenseItems value, $Res Function(_ExpenseItems) _then) =
      __$ExpenseItemsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @DecimalConverter() Decimal amount,
      String expenseListId,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class __$ExpenseItemsCopyWithImpl<$Res>
    implements _$ExpenseItemsCopyWith<$Res> {
  __$ExpenseItemsCopyWithImpl(this._self, this._then);

  final _ExpenseItems _self;
  final $Res Function(_ExpenseItems) _then;

  /// Create a copy of ExpenseItems
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? amount = null,
    Object? expenseListId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_ExpenseItems(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      expenseListId: null == expenseListId
          ? _self.expenseListId
          : expenseListId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
