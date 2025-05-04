// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_count_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillCountModel {
  String? get id;
  List<BillModel> get bills;
  double get expenses;
  bool get showExpenses;
  double get beginningBalance;
  bool get showBeginningBalance;
  Map<String, dynamic> get billsByType;
  DateTime? get date;
  double get billsTotal;
  double get totalWithExpenses;
  double get finalTotal;

  /// Create a copy of BillCountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BillCountModelCopyWith<BillCountModel> get copyWith =>
      _$BillCountModelCopyWithImpl<BillCountModel>(
          this as BillCountModel, _$identity);

  /// Serializes this BillCountModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BillCountModel &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.bills, bills) &&
            (identical(other.expenses, expenses) ||
                other.expenses == expenses) &&
            (identical(other.showExpenses, showExpenses) ||
                other.showExpenses == showExpenses) &&
            (identical(other.beginningBalance, beginningBalance) ||
                other.beginningBalance == beginningBalance) &&
            (identical(other.showBeginningBalance, showBeginningBalance) ||
                other.showBeginningBalance == showBeginningBalance) &&
            const DeepCollectionEquality()
                .equals(other.billsByType, billsByType) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.billsTotal, billsTotal) ||
                other.billsTotal == billsTotal) &&
            (identical(other.totalWithExpenses, totalWithExpenses) ||
                other.totalWithExpenses == totalWithExpenses) &&
            (identical(other.finalTotal, finalTotal) ||
                other.finalTotal == finalTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(bills),
      expenses,
      showExpenses,
      beginningBalance,
      showBeginningBalance,
      const DeepCollectionEquality().hash(billsByType),
      date,
      billsTotal,
      totalWithExpenses,
      finalTotal);

  @override
  String toString() {
    return 'BillCountModel(id: $id, bills: $bills, expenses: $expenses, showExpenses: $showExpenses, beginningBalance: $beginningBalance, showBeginningBalance: $showBeginningBalance, billsByType: $billsByType, date: $date, billsTotal: $billsTotal, totalWithExpenses: $totalWithExpenses, finalTotal: $finalTotal)';
  }
}

/// @nodoc
abstract mixin class $BillCountModelCopyWith<$Res> {
  factory $BillCountModelCopyWith(
          BillCountModel value, $Res Function(BillCountModel) _then) =
      _$BillCountModelCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      List<BillModel> bills,
      double expenses,
      bool showExpenses,
      double beginningBalance,
      bool showBeginningBalance,
      Map<String, dynamic> billsByType,
      DateTime? date,
      double billsTotal,
      double totalWithExpenses,
      double finalTotal});
}

/// @nodoc
class _$BillCountModelCopyWithImpl<$Res>
    implements $BillCountModelCopyWith<$Res> {
  _$BillCountModelCopyWithImpl(this._self, this._then);

  final BillCountModel _self;
  final $Res Function(BillCountModel) _then;

  /// Create a copy of BillCountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? bills = null,
    Object? expenses = null,
    Object? showExpenses = null,
    Object? beginningBalance = null,
    Object? showBeginningBalance = null,
    Object? billsByType = null,
    Object? date = freezed,
    Object? billsTotal = null,
    Object? totalWithExpenses = null,
    Object? finalTotal = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      bills: null == bills
          ? _self.bills
          : bills // ignore: cast_nullable_to_non_nullable
              as List<BillModel>,
      expenses: null == expenses
          ? _self.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as double,
      showExpenses: null == showExpenses
          ? _self.showExpenses
          : showExpenses // ignore: cast_nullable_to_non_nullable
              as bool,
      beginningBalance: null == beginningBalance
          ? _self.beginningBalance
          : beginningBalance // ignore: cast_nullable_to_non_nullable
              as double,
      showBeginningBalance: null == showBeginningBalance
          ? _self.showBeginningBalance
          : showBeginningBalance // ignore: cast_nullable_to_non_nullable
              as bool,
      billsByType: null == billsByType
          ? _self.billsByType
          : billsByType // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      billsTotal: null == billsTotal
          ? _self.billsTotal
          : billsTotal // ignore: cast_nullable_to_non_nullable
              as double,
      totalWithExpenses: null == totalWithExpenses
          ? _self.totalWithExpenses
          : totalWithExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      finalTotal: null == finalTotal
          ? _self.finalTotal
          : finalTotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _BillCountModel implements BillCountModel {
  const _BillCountModel(
      {this.id,
      final List<BillModel> bills = const [],
      this.expenses = 0,
      this.showExpenses = false,
      this.beginningBalance = 0,
      this.showBeginningBalance = false,
      final Map<String, dynamic> billsByType = const {},
      this.date,
      this.billsTotal = 0,
      this.totalWithExpenses = 0,
      this.finalTotal = 0})
      : _bills = bills,
        _billsByType = billsByType;
  factory _BillCountModel.fromJson(Map<String, dynamic> json) =>
      _$BillCountModelFromJson(json);

  @override
  final String? id;
  final List<BillModel> _bills;
  @override
  @JsonKey()
  List<BillModel> get bills {
    if (_bills is EqualUnmodifiableListView) return _bills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bills);
  }

  @override
  @JsonKey()
  final double expenses;
  @override
  @JsonKey()
  final bool showExpenses;
  @override
  @JsonKey()
  final double beginningBalance;
  @override
  @JsonKey()
  final bool showBeginningBalance;
  final Map<String, dynamic> _billsByType;
  @override
  @JsonKey()
  Map<String, dynamic> get billsByType {
    if (_billsByType is EqualUnmodifiableMapView) return _billsByType;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_billsByType);
  }

  @override
  final DateTime? date;
  @override
  @JsonKey()
  final double billsTotal;
  @override
  @JsonKey()
  final double totalWithExpenses;
  @override
  @JsonKey()
  final double finalTotal;

  /// Create a copy of BillCountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BillCountModelCopyWith<_BillCountModel> get copyWith =>
      __$BillCountModelCopyWithImpl<_BillCountModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BillCountModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BillCountModel &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._bills, _bills) &&
            (identical(other.expenses, expenses) ||
                other.expenses == expenses) &&
            (identical(other.showExpenses, showExpenses) ||
                other.showExpenses == showExpenses) &&
            (identical(other.beginningBalance, beginningBalance) ||
                other.beginningBalance == beginningBalance) &&
            (identical(other.showBeginningBalance, showBeginningBalance) ||
                other.showBeginningBalance == showBeginningBalance) &&
            const DeepCollectionEquality()
                .equals(other._billsByType, _billsByType) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.billsTotal, billsTotal) ||
                other.billsTotal == billsTotal) &&
            (identical(other.totalWithExpenses, totalWithExpenses) ||
                other.totalWithExpenses == totalWithExpenses) &&
            (identical(other.finalTotal, finalTotal) ||
                other.finalTotal == finalTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_bills),
      expenses,
      showExpenses,
      beginningBalance,
      showBeginningBalance,
      const DeepCollectionEquality().hash(_billsByType),
      date,
      billsTotal,
      totalWithExpenses,
      finalTotal);

  @override
  String toString() {
    return 'BillCountModel(id: $id, bills: $bills, expenses: $expenses, showExpenses: $showExpenses, beginningBalance: $beginningBalance, showBeginningBalance: $showBeginningBalance, billsByType: $billsByType, date: $date, billsTotal: $billsTotal, totalWithExpenses: $totalWithExpenses, finalTotal: $finalTotal)';
  }
}

/// @nodoc
abstract mixin class _$BillCountModelCopyWith<$Res>
    implements $BillCountModelCopyWith<$Res> {
  factory _$BillCountModelCopyWith(
          _BillCountModel value, $Res Function(_BillCountModel) _then) =
      __$BillCountModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      List<BillModel> bills,
      double expenses,
      bool showExpenses,
      double beginningBalance,
      bool showBeginningBalance,
      Map<String, dynamic> billsByType,
      DateTime? date,
      double billsTotal,
      double totalWithExpenses,
      double finalTotal});
}

/// @nodoc
class __$BillCountModelCopyWithImpl<$Res>
    implements _$BillCountModelCopyWith<$Res> {
  __$BillCountModelCopyWithImpl(this._self, this._then);

  final _BillCountModel _self;
  final $Res Function(_BillCountModel) _then;

  /// Create a copy of BillCountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? bills = null,
    Object? expenses = null,
    Object? showExpenses = null,
    Object? beginningBalance = null,
    Object? showBeginningBalance = null,
    Object? billsByType = null,
    Object? date = freezed,
    Object? billsTotal = null,
    Object? totalWithExpenses = null,
    Object? finalTotal = null,
  }) {
    return _then(_BillCountModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      bills: null == bills
          ? _self._bills
          : bills // ignore: cast_nullable_to_non_nullable
              as List<BillModel>,
      expenses: null == expenses
          ? _self.expenses
          : expenses // ignore: cast_nullable_to_non_nullable
              as double,
      showExpenses: null == showExpenses
          ? _self.showExpenses
          : showExpenses // ignore: cast_nullable_to_non_nullable
              as bool,
      beginningBalance: null == beginningBalance
          ? _self.beginningBalance
          : beginningBalance // ignore: cast_nullable_to_non_nullable
              as double,
      showBeginningBalance: null == showBeginningBalance
          ? _self.showBeginningBalance
          : showBeginningBalance // ignore: cast_nullable_to_non_nullable
              as bool,
      billsByType: null == billsByType
          ? _self._billsByType
          : billsByType // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      date: freezed == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      billsTotal: null == billsTotal
          ? _self.billsTotal
          : billsTotal // ignore: cast_nullable_to_non_nullable
              as double,
      totalWithExpenses: null == totalWithExpenses
          ? _self.totalWithExpenses
          : totalWithExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      finalTotal: null == finalTotal
          ? _self.finalTotal
          : finalTotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
