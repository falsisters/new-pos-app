// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_bill_count_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateBillCountRequestModel {
  String? get date;
  double? get startingAmount;
  double? get totalCash;
  double? get expenses;
  bool? get showExpenses;
  double? get beginningBalance;
  bool? get showBeginningBalance;
  List<BillModel>? get bills;

  /// Create a copy of CreateBillCountRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateBillCountRequestModelCopyWith<CreateBillCountRequestModel>
      get copyWith => _$CreateBillCountRequestModelCopyWithImpl<
              CreateBillCountRequestModel>(
          this as CreateBillCountRequestModel, _$identity);

  /// Serializes this CreateBillCountRequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateBillCountRequestModel &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startingAmount, startingAmount) ||
                other.startingAmount == startingAmount) &&
            (identical(other.totalCash, totalCash) ||
                other.totalCash == totalCash) &&
            (identical(other.expenses, expenses) ||
                other.expenses == expenses) &&
            (identical(other.showExpenses, showExpenses) ||
                other.showExpenses == showExpenses) &&
            (identical(other.beginningBalance, beginningBalance) ||
                other.beginningBalance == beginningBalance) &&
            (identical(other.showBeginningBalance, showBeginningBalance) ||
                other.showBeginningBalance == showBeginningBalance) &&
            const DeepCollectionEquality().equals(other.bills, bills));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      startingAmount,
      totalCash,
      expenses,
      showExpenses,
      beginningBalance,
      showBeginningBalance,
      const DeepCollectionEquality().hash(bills));

  @override
  String toString() {
    return 'CreateBillCountRequestModel(date: $date, startingAmount: $startingAmount, totalCash: $totalCash, expenses: $expenses, showExpenses: $showExpenses, beginningBalance: $beginningBalance, showBeginningBalance: $showBeginningBalance, bills: $bills)';
  }
}

/// @nodoc
abstract mixin class $CreateBillCountRequestModelCopyWith<$Res> {
  factory $CreateBillCountRequestModelCopyWith(
          CreateBillCountRequestModel value,
          $Res Function(CreateBillCountRequestModel) _then) =
      _$CreateBillCountRequestModelCopyWithImpl;
  @useResult
  $Res call(
      {String? date,
      double? startingAmount,
      double? totalCash,
      double? expenses,
      bool? showExpenses,
      double? beginningBalance,
      bool? showBeginningBalance,
      List<BillModel>? bills});
}

/// @nodoc
class _$CreateBillCountRequestModelCopyWithImpl<$Res>
    implements $CreateBillCountRequestModelCopyWith<$Res> {
  _$CreateBillCountRequestModelCopyWithImpl(this._self, this._then);

  final CreateBillCountRequestModel _self;
  final $Res Function(CreateBillCountRequestModel) _then;

  /// Create a copy of CreateBillCountRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? startingAmount = freezed,
    Object? totalCash = freezed,
    Object? expenses = freezed,
    Object? showExpenses = freezed,
    Object? beginningBalance = freezed,
    Object? showBeginningBalance = freezed,
    Object? bills = freezed,
  }) {
    return _then(_self.copyWith(
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      startingAmount: freezed == startingAmount
          ? _self.startingAmount
          : startingAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      totalCash: freezed == totalCash
          ? _self.totalCash
          : totalCash // ignore: cast_nullable_to_non_nullable
              as double?,
      expenses: freezed == expenses
          ? _self.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as double?,
      showExpenses: freezed == showExpenses
          ? _self.showExpenses
          : showExpenses // ignore: cast_nullable_to_non_nullable
              as bool?,
      beginningBalance: freezed == beginningBalance
          ? _self.beginningBalance
          : beginningBalance // ignore: cast_nullable_to_non_nullable
              as double?,
      showBeginningBalance: freezed == showBeginningBalance
          ? _self.showBeginningBalance
          : showBeginningBalance // ignore: cast_nullable_to_non_nullable
              as bool?,
      bills: freezed == bills
          ? _self.bills
          : bills // ignore: cast_nullable_to_non_nullable
              as List<BillModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CreateBillCountRequestModel implements CreateBillCountRequestModel {
  const _CreateBillCountRequestModel(
      {this.date,
      this.startingAmount,
      this.totalCash,
      this.expenses,
      this.showExpenses,
      this.beginningBalance,
      this.showBeginningBalance,
      final List<BillModel>? bills})
      : _bills = bills;
  factory _CreateBillCountRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateBillCountRequestModelFromJson(json);

  @override
  final String? date;
  @override
  final double? startingAmount;
  @override
  final double? totalCash;
  @override
  final double? expenses;
  @override
  final bool? showExpenses;
  @override
  final double? beginningBalance;
  @override
  final bool? showBeginningBalance;
  final List<BillModel>? _bills;
  @override
  List<BillModel>? get bills {
    final value = _bills;
    if (value == null) return null;
    if (_bills is EqualUnmodifiableListView) return _bills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of CreateBillCountRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateBillCountRequestModelCopyWith<_CreateBillCountRequestModel>
      get copyWith => __$CreateBillCountRequestModelCopyWithImpl<
          _CreateBillCountRequestModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateBillCountRequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateBillCountRequestModel &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startingAmount, startingAmount) ||
                other.startingAmount == startingAmount) &&
            (identical(other.totalCash, totalCash) ||
                other.totalCash == totalCash) &&
            (identical(other.expenses, expenses) ||
                other.expenses == expenses) &&
            (identical(other.showExpenses, showExpenses) ||
                other.showExpenses == showExpenses) &&
            (identical(other.beginningBalance, beginningBalance) ||
                other.beginningBalance == beginningBalance) &&
            (identical(other.showBeginningBalance, showBeginningBalance) ||
                other.showBeginningBalance == showBeginningBalance) &&
            const DeepCollectionEquality().equals(other._bills, _bills));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      startingAmount,
      totalCash,
      expenses,
      showExpenses,
      beginningBalance,
      showBeginningBalance,
      const DeepCollectionEquality().hash(_bills));

  @override
  String toString() {
    return 'CreateBillCountRequestModel(date: $date, startingAmount: $startingAmount, totalCash: $totalCash, expenses: $expenses, showExpenses: $showExpenses, beginningBalance: $beginningBalance, showBeginningBalance: $showBeginningBalance, bills: $bills)';
  }
}

/// @nodoc
abstract mixin class _$CreateBillCountRequestModelCopyWith<$Res>
    implements $CreateBillCountRequestModelCopyWith<$Res> {
  factory _$CreateBillCountRequestModelCopyWith(
          _CreateBillCountRequestModel value,
          $Res Function(_CreateBillCountRequestModel) _then) =
      __$CreateBillCountRequestModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? date,
      double? startingAmount,
      double? totalCash,
      double? expenses,
      bool? showExpenses,
      double? beginningBalance,
      bool? showBeginningBalance,
      List<BillModel>? bills});
}

/// @nodoc
class __$CreateBillCountRequestModelCopyWithImpl<$Res>
    implements _$CreateBillCountRequestModelCopyWith<$Res> {
  __$CreateBillCountRequestModelCopyWithImpl(this._self, this._then);

  final _CreateBillCountRequestModel _self;
  final $Res Function(_CreateBillCountRequestModel) _then;

  /// Create a copy of CreateBillCountRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? date = freezed,
    Object? startingAmount = freezed,
    Object? totalCash = freezed,
    Object? expenses = freezed,
    Object? showExpenses = freezed,
    Object? beginningBalance = freezed,
    Object? showBeginningBalance = freezed,
    Object? bills = freezed,
  }) {
    return _then(_CreateBillCountRequestModel(
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      startingAmount: freezed == startingAmount
          ? _self.startingAmount
          : startingAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      totalCash: freezed == totalCash
          ? _self.totalCash
          : totalCash // ignore: cast_nullable_to_non_nullable
              as double?,
      expenses: freezed == expenses
          ? _self.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as double?,
      showExpenses: freezed == showExpenses
          ? _self.showExpenses
          : showExpenses // ignore: cast_nullable_to_non_nullable
              as bool?,
      beginningBalance: freezed == beginningBalance
          ? _self.beginningBalance
          : beginningBalance // ignore: cast_nullable_to_non_nullable
              as double?,
      showBeginningBalance: freezed == showBeginningBalance
          ? _self.showBeginningBalance
          : showBeginningBalance // ignore: cast_nullable_to_non_nullable
              as bool?,
      bills: freezed == bills
          ? _self._bills
          : bills // ignore: cast_nullable_to_non_nullable
              as List<BillModel>?,
    ));
  }
}

// dart format on
