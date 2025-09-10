// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseList {
  String get id;
  String? get userId;
  String? get cashierId;
  String get createdAt;
  String get updatedAt;
  List<ExpenseItems> get expenseItems;

  /// Create a copy of ExpenseList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExpenseListCopyWith<ExpenseList> get copyWith =>
      _$ExpenseListCopyWithImpl<ExpenseList>(this as ExpenseList, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExpenseList &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other.expenseItems, expenseItems));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, userId, cashierId, createdAt,
      updatedAt, const DeepCollectionEquality().hash(expenseItems));

  @override
  String toString() {
    return 'ExpenseList(id: $id, userId: $userId, cashierId: $cashierId, createdAt: $createdAt, updatedAt: $updatedAt, expenseItems: $expenseItems)';
  }
}

/// @nodoc
abstract mixin class $ExpenseListCopyWith<$Res> {
  factory $ExpenseListCopyWith(
          ExpenseList value, $Res Function(ExpenseList) _then) =
      _$ExpenseListCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? userId,
      String? cashierId,
      String createdAt,
      String updatedAt,
      List<ExpenseItems> expenseItems});
}

/// @nodoc
class _$ExpenseListCopyWithImpl<$Res> implements $ExpenseListCopyWith<$Res> {
  _$ExpenseListCopyWithImpl(this._self, this._then);

  final ExpenseList _self;
  final $Res Function(ExpenseList) _then;

  /// Create a copy of ExpenseList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? cashierId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? expenseItems = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      cashierId: freezed == cashierId
          ? _self.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      expenseItems: null == expenseItems
          ? _self.expenseItems
          : expenseItems // ignore: cast_nullable_to_non_nullable
              as List<ExpenseItems>,
    ));
  }
}

/// @nodoc

class _ExpenseList implements ExpenseList {
  const _ExpenseList(
      {required this.id,
      this.userId,
      this.cashierId,
      required this.createdAt,
      required this.updatedAt,
      required final List<ExpenseItems> expenseItems})
      : _expenseItems = expenseItems;

  @override
  final String id;
  @override
  final String? userId;
  @override
  final String? cashierId;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  final List<ExpenseItems> _expenseItems;
  @override
  List<ExpenseItems> get expenseItems {
    if (_expenseItems is EqualUnmodifiableListView) return _expenseItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenseItems);
  }

  /// Create a copy of ExpenseList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExpenseListCopyWith<_ExpenseList> get copyWith =>
      __$ExpenseListCopyWithImpl<_ExpenseList>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExpenseList &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._expenseItems, _expenseItems));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, userId, cashierId, createdAt,
      updatedAt, const DeepCollectionEquality().hash(_expenseItems));

  @override
  String toString() {
    return 'ExpenseList(id: $id, userId: $userId, cashierId: $cashierId, createdAt: $createdAt, updatedAt: $updatedAt, expenseItems: $expenseItems)';
  }
}

/// @nodoc
abstract mixin class _$ExpenseListCopyWith<$Res>
    implements $ExpenseListCopyWith<$Res> {
  factory _$ExpenseListCopyWith(
          _ExpenseList value, $Res Function(_ExpenseList) _then) =
      __$ExpenseListCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String? userId,
      String? cashierId,
      String createdAt,
      String updatedAt,
      List<ExpenseItems> expenseItems});
}

/// @nodoc
class __$ExpenseListCopyWithImpl<$Res> implements _$ExpenseListCopyWith<$Res> {
  __$ExpenseListCopyWithImpl(this._self, this._then);

  final _ExpenseList _self;
  final $Res Function(_ExpenseList) _then;

  /// Create a copy of ExpenseList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? cashierId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? expenseItems = null,
  }) {
    return _then(_ExpenseList(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      cashierId: freezed == cashierId
          ? _self.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      expenseItems: null == expenseItems
          ? _self._expenseItems
          : expenseItems // ignore: cast_nullable_to_non_nullable
              as List<ExpenseItems>,
    ));
  }
}

// dart format on
