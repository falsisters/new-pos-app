// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_expense_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateExpenseList {
  List<ExpenseItemDto> get expenseItems;

  /// Create a copy of CreateExpenseList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateExpenseListCopyWith<CreateExpenseList> get copyWith =>
      _$CreateExpenseListCopyWithImpl<CreateExpenseList>(
          this as CreateExpenseList, _$identity);

  /// Serializes this CreateExpenseList to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateExpenseList &&
            const DeepCollectionEquality()
                .equals(other.expenseItems, expenseItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(expenseItems));

  @override
  String toString() {
    return 'CreateExpenseList(expenseItems: $expenseItems)';
  }
}

/// @nodoc
abstract mixin class $CreateExpenseListCopyWith<$Res> {
  factory $CreateExpenseListCopyWith(
          CreateExpenseList value, $Res Function(CreateExpenseList) _then) =
      _$CreateExpenseListCopyWithImpl;
  @useResult
  $Res call({List<ExpenseItemDto> expenseItems});
}

/// @nodoc
class _$CreateExpenseListCopyWithImpl<$Res>
    implements $CreateExpenseListCopyWith<$Res> {
  _$CreateExpenseListCopyWithImpl(this._self, this._then);

  final CreateExpenseList _self;
  final $Res Function(CreateExpenseList) _then;

  /// Create a copy of CreateExpenseList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expenseItems = null,
  }) {
    return _then(_self.copyWith(
      expenseItems: null == expenseItems
          ? _self.expenseItems
          : expenseItems // ignore: cast_nullable_to_non_nullable
              as List<ExpenseItemDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CreateExpenseList implements CreateExpenseList {
  const _CreateExpenseList({required final List<ExpenseItemDto> expenseItems})
      : _expenseItems = expenseItems;
  factory _CreateExpenseList.fromJson(Map<String, dynamic> json) =>
      _$CreateExpenseListFromJson(json);

  final List<ExpenseItemDto> _expenseItems;
  @override
  List<ExpenseItemDto> get expenseItems {
    if (_expenseItems is EqualUnmodifiableListView) return _expenseItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenseItems);
  }

  /// Create a copy of CreateExpenseList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateExpenseListCopyWith<_CreateExpenseList> get copyWith =>
      __$CreateExpenseListCopyWithImpl<_CreateExpenseList>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateExpenseListToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateExpenseList &&
            const DeepCollectionEquality()
                .equals(other._expenseItems, _expenseItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_expenseItems));

  @override
  String toString() {
    return 'CreateExpenseList(expenseItems: $expenseItems)';
  }
}

/// @nodoc
abstract mixin class _$CreateExpenseListCopyWith<$Res>
    implements $CreateExpenseListCopyWith<$Res> {
  factory _$CreateExpenseListCopyWith(
          _CreateExpenseList value, $Res Function(_CreateExpenseList) _then) =
      __$CreateExpenseListCopyWithImpl;
  @override
  @useResult
  $Res call({List<ExpenseItemDto> expenseItems});
}

/// @nodoc
class __$CreateExpenseListCopyWithImpl<$Res>
    implements _$CreateExpenseListCopyWith<$Res> {
  __$CreateExpenseListCopyWithImpl(this._self, this._then);

  final _CreateExpenseList _self;
  final $Res Function(_CreateExpenseList) _then;

  /// Create a copy of CreateExpenseList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? expenseItems = null,
  }) {
    return _then(_CreateExpenseList(
      expenseItems: null == expenseItems
          ? _self._expenseItems
          : expenseItems // ignore: cast_nullable_to_non_nullable
              as List<ExpenseItemDto>,
    ));
  }
}

// dart format on
