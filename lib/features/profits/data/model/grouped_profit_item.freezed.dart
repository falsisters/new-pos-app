// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grouped_profit_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupedProfitItem {
  String get productName;
  @DecimalConverter()
  Decimal get profitPerUnit;
  @DecimalConverter()
  Decimal get totalQuantity;
  @DecimalConverter()
  Decimal get totalProfit;
  int get orders;
  String get formattedSummary;

  /// Create a copy of GroupedProfitItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupedProfitItemCopyWith<GroupedProfitItem> get copyWith =>
      _$GroupedProfitItemCopyWithImpl<GroupedProfitItem>(
          this as GroupedProfitItem, _$identity);

  /// Serializes this GroupedProfitItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupedProfitItem &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.profitPerUnit, profitPerUnit) ||
                other.profitPerUnit == profitPerUnit) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalProfit, totalProfit) ||
                other.totalProfit == totalProfit) &&
            (identical(other.orders, orders) || other.orders == orders) &&
            (identical(other.formattedSummary, formattedSummary) ||
                other.formattedSummary == formattedSummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productName, profitPerUnit,
      totalQuantity, totalProfit, orders, formattedSummary);

  @override
  String toString() {
    return 'GroupedProfitItem(productName: $productName, profitPerUnit: $profitPerUnit, totalQuantity: $totalQuantity, totalProfit: $totalProfit, orders: $orders, formattedSummary: $formattedSummary)';
  }
}

/// @nodoc
abstract mixin class $GroupedProfitItemCopyWith<$Res> {
  factory $GroupedProfitItemCopyWith(
          GroupedProfitItem value, $Res Function(GroupedProfitItem) _then) =
      _$GroupedProfitItemCopyWithImpl;
  @useResult
  $Res call(
      {String productName,
      @DecimalConverter() Decimal profitPerUnit,
      @DecimalConverter() Decimal totalQuantity,
      @DecimalConverter() Decimal totalProfit,
      int orders,
      String formattedSummary});
}

/// @nodoc
class _$GroupedProfitItemCopyWithImpl<$Res>
    implements $GroupedProfitItemCopyWith<$Res> {
  _$GroupedProfitItemCopyWithImpl(this._self, this._then);

  final GroupedProfitItem _self;
  final $Res Function(GroupedProfitItem) _then;

  /// Create a copy of GroupedProfitItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productName = null,
    Object? profitPerUnit = null,
    Object? totalQuantity = null,
    Object? totalProfit = null,
    Object? orders = null,
    Object? formattedSummary = null,
  }) {
    return _then(_self.copyWith(
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      profitPerUnit: null == profitPerUnit
          ? _self.profitPerUnit
          : profitPerUnit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalQuantity: null == totalQuantity
          ? _self.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalProfit: null == totalProfit
          ? _self.totalProfit
          : totalProfit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      orders: null == orders
          ? _self.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as int,
      formattedSummary: null == formattedSummary
          ? _self.formattedSummary
          : formattedSummary // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _GroupedProfitItem implements GroupedProfitItem {
  const _GroupedProfitItem(
      {required this.productName,
      @DecimalConverter() required this.profitPerUnit,
      @DecimalConverter() required this.totalQuantity,
      @DecimalConverter() required this.totalProfit,
      required this.orders,
      required this.formattedSummary});
  factory _GroupedProfitItem.fromJson(Map<String, dynamic> json) =>
      _$GroupedProfitItemFromJson(json);

  @override
  final String productName;
  @override
  @DecimalConverter()
  final Decimal profitPerUnit;
  @override
  @DecimalConverter()
  final Decimal totalQuantity;
  @override
  @DecimalConverter()
  final Decimal totalProfit;
  @override
  final int orders;
  @override
  final String formattedSummary;

  /// Create a copy of GroupedProfitItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GroupedProfitItemCopyWith<_GroupedProfitItem> get copyWith =>
      __$GroupedProfitItemCopyWithImpl<_GroupedProfitItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GroupedProfitItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GroupedProfitItem &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.profitPerUnit, profitPerUnit) ||
                other.profitPerUnit == profitPerUnit) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalProfit, totalProfit) ||
                other.totalProfit == totalProfit) &&
            (identical(other.orders, orders) || other.orders == orders) &&
            (identical(other.formattedSummary, formattedSummary) ||
                other.formattedSummary == formattedSummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productName, profitPerUnit,
      totalQuantity, totalProfit, orders, formattedSummary);

  @override
  String toString() {
    return 'GroupedProfitItem(productName: $productName, profitPerUnit: $profitPerUnit, totalQuantity: $totalQuantity, totalProfit: $totalProfit, orders: $orders, formattedSummary: $formattedSummary)';
  }
}

/// @nodoc
abstract mixin class _$GroupedProfitItemCopyWith<$Res>
    implements $GroupedProfitItemCopyWith<$Res> {
  factory _$GroupedProfitItemCopyWith(
          _GroupedProfitItem value, $Res Function(_GroupedProfitItem) _then) =
      __$GroupedProfitItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String productName,
      @DecimalConverter() Decimal profitPerUnit,
      @DecimalConverter() Decimal totalQuantity,
      @DecimalConverter() Decimal totalProfit,
      int orders,
      String formattedSummary});
}

/// @nodoc
class __$GroupedProfitItemCopyWithImpl<$Res>
    implements _$GroupedProfitItemCopyWith<$Res> {
  __$GroupedProfitItemCopyWithImpl(this._self, this._then);

  final _GroupedProfitItem _self;
  final $Res Function(_GroupedProfitItem) _then;

  /// Create a copy of GroupedProfitItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? productName = null,
    Object? profitPerUnit = null,
    Object? totalQuantity = null,
    Object? totalProfit = null,
    Object? orders = null,
    Object? formattedSummary = null,
  }) {
    return _then(_GroupedProfitItem(
      productName: null == productName
          ? _self.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      profitPerUnit: null == profitPerUnit
          ? _self.profitPerUnit
          : profitPerUnit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalQuantity: null == totalQuantity
          ? _self.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as Decimal,
      totalProfit: null == totalProfit
          ? _self.totalProfit
          : totalProfit // ignore: cast_nullable_to_non_nullable
              as Decimal,
      orders: null == orders
          ? _self.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as int,
      formattedSummary: null == formattedSummary
          ? _self.formattedSummary
          : formattedSummary // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
