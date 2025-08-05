// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grouped_sales_check_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupedSalesCheckItem {
  String get productName; // e.g., "Rice 50KG"
  List<GroupedSaleDetail> get items;
  @DecimalConverter()
  Decimal get totalQuantity;
  @DecimalConverter()
  Decimal get totalAmount;
  PaymentTotals get paymentTotals;

  /// Create a copy of GroupedSalesCheckItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupedSalesCheckItemCopyWith<GroupedSalesCheckItem> get copyWith =>
      _$GroupedSalesCheckItemCopyWithImpl<GroupedSalesCheckItem>(
          this as GroupedSalesCheckItem, _$identity);

  /// Serializes this GroupedSalesCheckItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupedSalesCheckItem &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentTotals, paymentTotals) ||
                other.paymentTotals == paymentTotals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      productName,
      const DeepCollectionEquality().hash(items),
      totalQuantity,
      totalAmount,
      paymentTotals);

  @override
  String toString() {
    return 'GroupedSalesCheckItem(productName: $productName, items: $items, totalQuantity: $totalQuantity, totalAmount: $totalAmount, paymentTotals: $paymentTotals)';
  }
}

/// @nodoc
abstract mixin class $GroupedSalesCheckItemCopyWith<$Res> {
  factory $GroupedSalesCheckItemCopyWith(GroupedSalesCheckItem value,
          $Res Function(GroupedSalesCheckItem) _then) =
      _$GroupedSalesCheckItemCopyWithImpl;
  @useResult
  $Res call(
      {String productName,
      List<GroupedSaleDetail> items,
      @DecimalConverter() Decimal totalQuantity,
      @DecimalConverter() Decimal totalAmount,
      PaymentTotals paymentTotals});

  $PaymentTotalsCopyWith<$Res> get paymentTotals;
}

/// @nodoc
class _$GroupedSalesCheckItemCopyWithImpl<$Res>
    implements $GroupedSalesCheckItemCopyWith<$Res> {
  _$GroupedSalesCheckItemCopyWithImpl(this._self, this._then);

  final GroupedSalesCheckItem _self;
  final $Res Function(GroupedSalesCheckItem) _then;

  /// Create a copy of GroupedSalesCheckItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? items = null,
    Object? totalQuantity = null,
    Object? totalAmount = null,
    Object? paymentTotals = null,
  }) {
    return _then(_self.copyWith(
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<GroupedSaleDetail>,
      totalQuantity: null == totalQuantity
          ? _self.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      paymentTotals: null == paymentTotals
          ? _self.paymentTotals
          : paymentTotals // ignore: cast_nullable_to_non_nullable
              as PaymentTotals,
    ));
  }

  /// Create a copy of GroupedSalesCheckItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentTotalsCopyWith<$Res> get paymentTotals {
    return $PaymentTotalsCopyWith<$Res>(_self.paymentTotals, (value) {
      return _then(_self.copyWith(paymentTotals: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _GroupedSalesCheckItem implements GroupedSalesCheckItem {
  const _GroupedSalesCheckItem(
      {required this.productName,
      required final List<GroupedSaleDetail> items,
      @DecimalConverter() required this.totalQuantity,
      @DecimalConverter() required this.totalAmount,
      required this.paymentTotals})
      : _items = items;
  factory _GroupedSalesCheckItem.fromJson(Map<String, dynamic> json) =>
      _$GroupedSalesCheckItemFromJson(json);

  @override
  final String productName;
// e.g., "Rice 50KG"
  final List<GroupedSaleDetail> _items;
// e.g., "Rice 50KG"
  @override
  List<GroupedSaleDetail> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @DecimalConverter()
  final Decimal totalQuantity;
  @override
  @DecimalConverter()
  final Decimal totalAmount;
  @override
  final PaymentTotals paymentTotals;

  /// Create a copy of GroupedSalesCheckItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupedSalesCheckItemCopyWith<_GroupedSalesCheckItem> get copyWith =>
      __$GroupedSalesCheckItemCopyWithImpl<_GroupedSalesCheckItem>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupedSalesCheckItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GroupedSalesCheckItem &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentTotals, paymentTotals) ||
                other.paymentTotals == paymentTotals));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      productName,
      const DeepCollectionEquality().hash(_items),
      totalQuantity,
      totalAmount,
      paymentTotals);

  @override
  String toString() {
    return 'GroupedSalesCheckItem(productName: $productName, items: $items, totalQuantity: $totalQuantity, totalAmount: $totalAmount, paymentTotals: $paymentTotals)';
  }
}

/// @nodoc
abstract mixin class _$GroupedSalesCheckItemCopyWith<$Res>
    implements $GroupedSalesCheckItemCopyWith<$Res> {
  factory _$GroupedSalesCheckItemCopyWith(_GroupedSalesCheckItem value,
          $Res Function(_GroupedSalesCheckItem) _then) =
      __$GroupedSalesCheckItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String productName,
      List<GroupedSaleDetail> items,
      @DecimalConverter() Decimal totalQuantity,
      @DecimalConverter() Decimal totalAmount,
      PaymentTotals paymentTotals});

  @override
  $PaymentTotalsCopyWith<$Res> get paymentTotals;
}

/// @nodoc
class __$GroupedSalesCheckItemCopyWithImpl<$Res>
    implements _$GroupedSalesCheckItemCopyWith<$Res> {
  __$GroupedSalesCheckItemCopyWithImpl(this._self, this._then);

  final _GroupedSalesCheckItem _self;
  final $Res Function(_GroupedSalesCheckItem) _then;

  /// Create a copy of GroupedSalesCheckItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? productName = null,
    Object? items = null,
    Object? totalQuantity = null,
    Object? totalAmount = null,
    Object? paymentTotals = null,
  }) {
    return _then(_GroupedSalesCheckItem(
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<GroupedSaleDetail>,
      totalQuantity: null == totalQuantity
          ? _self.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalAmount: null == totalAmount
          ? _self.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as Decimal,
      paymentTotals: null == paymentTotals
          ? _self.paymentTotals
          : paymentTotals // ignore: cast_nullable_to_non_nullable
              as PaymentTotals,
    ));
  }

  /// Create a copy of GroupedSalesCheckItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentTotalsCopyWith<$Res> get paymentTotals {
    return $PaymentTotalsCopyWith<$Res>(_self.paymentTotals, (value) {
      return _then(_self.copyWith(paymentTotals: value));
    });
  }
}

// dart format on
