// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_check.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalesCheck {
  String get id;
  String
      get cashierId; // Consider adding Cashier details if needed and provided by the backend
  double get totalAmount;
  PaymentMethod get paymentMethod;
  DateTime get createdAt;
  DateTime get updatedAt;
  @JsonKey(name: 'SaleItem')
  List<SaleItemCheck> get saleItems;

  /// Create a copy of SalesCheck
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SalesCheckCopyWith<SalesCheck> get copyWith =>
      _$SalesCheckCopyWithImpl<SalesCheck>(this as SalesCheck, _$identity);

  /// Serializes this SalesCheck to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SalesCheck &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.saleItems, saleItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      cashierId,
      totalAmount,
      paymentMethod,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(saleItems));

  @override
  String toString() {
    return 'SalesCheck(id: $id, cashierId: $cashierId, totalAmount: $totalAmount, paymentMethod: $paymentMethod, createdAt: $createdAt, updatedAt: $updatedAt, saleItems: $saleItems)';
  }
}

/// @nodoc
abstract mixin class $SalesCheckCopyWith<$Res> {
  factory $SalesCheckCopyWith(
          SalesCheck value, $Res Function(SalesCheck) _then) =
      _$SalesCheckCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String cashierId,
      double totalAmount,
      PaymentMethod paymentMethod,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'SaleItem') List<SaleItemCheck> saleItems});
}

/// @nodoc
class _$SalesCheckCopyWithImpl<$Res> implements $SalesCheckCopyWith<$Res> {
  _$SalesCheckCopyWithImpl(this._self, this._then);

  final SalesCheck _self;
  final $Res Function(SalesCheck) _then;

  /// Create a copy of SalesCheck
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cashierId = null,
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? saleItems = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cashierId: null == cashierId
          ? _self.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      saleItems: null == saleItems
          ? _self.saleItems
          : saleItems // ignore: cast_nullable_to_non_nullable
              as List<SaleItemCheck>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SalesCheck implements SalesCheck {
  const _SalesCheck(
      {required this.id,
      required this.cashierId,
      required this.totalAmount,
      required this.paymentMethod,
      required this.createdAt,
      required this.updatedAt,
      @JsonKey(name: 'SaleItem') required final List<SaleItemCheck> saleItems})
      : _saleItems = saleItems;
  factory _SalesCheck.fromJson(Map<String, dynamic> json) =>
      _$SalesCheckFromJson(json);

  @override
  final String id;
  @override
  final String cashierId;
// Consider adding Cashier details if needed and provided by the backend
  @override
  final double totalAmount;
  @override
  final PaymentMethod paymentMethod;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<SaleItemCheck> _saleItems;
  @override
  @JsonKey(name: 'SaleItem')
  List<SaleItemCheck> get saleItems {
    if (_saleItems is EqualUnmodifiableListView) return _saleItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_saleItems);
  }

  /// Create a copy of SalesCheck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SalesCheckCopyWith<_SalesCheck> get copyWith =>
      __$SalesCheckCopyWithImpl<_SalesCheck>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SalesCheckToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SalesCheck &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._saleItems, _saleItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      cashierId,
      totalAmount,
      paymentMethod,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_saleItems));

  @override
  String toString() {
    return 'SalesCheck(id: $id, cashierId: $cashierId, totalAmount: $totalAmount, paymentMethod: $paymentMethod, createdAt: $createdAt, updatedAt: $updatedAt, saleItems: $saleItems)';
  }
}

/// @nodoc
abstract mixin class _$SalesCheckCopyWith<$Res>
    implements $SalesCheckCopyWith<$Res> {
  factory _$SalesCheckCopyWith(
          _SalesCheck value, $Res Function(_SalesCheck) _then) =
      __$SalesCheckCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String cashierId,
      double totalAmount,
      PaymentMethod paymentMethod,
      DateTime createdAt,
      DateTime updatedAt,
      @JsonKey(name: 'SaleItem') List<SaleItemCheck> saleItems});
}

/// @nodoc
class __$SalesCheckCopyWithImpl<$Res> implements _$SalesCheckCopyWith<$Res> {
  __$SalesCheckCopyWithImpl(this._self, this._then);

  final _SalesCheck _self;
  final $Res Function(_SalesCheck) _then;

  /// Create a copy of SalesCheck
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? cashierId = null,
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? saleItems = null,
  }) {
    return _then(_SalesCheck(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      cashierId: null == cashierId
          ? _self.cashierId
          : cashierId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      saleItems: null == saleItems
          ? _self._saleItems
          : saleItems // ignore: cast_nullable_to_non_nullable
              as List<SaleItemCheck>,
    ));
  }
}

// dart format on
