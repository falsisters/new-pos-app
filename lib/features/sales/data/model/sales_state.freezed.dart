// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SalesState {
  CartModel get cart;
  List<SaleModel> get sales;
  String? get orderId;
  String? get error;
  DateTime? get selectedDate;

  /// Create a copy of SalesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SalesStateCopyWith<SalesState> get copyWith =>
      _$SalesStateCopyWithImpl<SalesState>(this as SalesState, _$identity);

  /// Serializes this SalesState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SalesState &&
            (identical(other.cart, cart) || other.cart == cart) &&
            const DeepCollectionEquality().equals(other.sales, sales) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, cart,
      const DeepCollectionEquality().hash(sales), orderId, error, selectedDate);

  @override
  String toString() {
    return 'SalesState(cart: $cart, sales: $sales, orderId: $orderId, error: $error, selectedDate: $selectedDate)';
  }
}

/// @nodoc
abstract mixin class $SalesStateCopyWith<$Res> {
  factory $SalesStateCopyWith(
          SalesState value, $Res Function(SalesState) _then) =
      _$SalesStateCopyWithImpl;
  @useResult
  $Res call(
      {CartModel cart,
      List<SaleModel> sales,
      String? orderId,
      String? error,
      DateTime? selectedDate});

  $CartModelCopyWith<$Res> get cart;
}

/// @nodoc
class _$SalesStateCopyWithImpl<$Res> implements $SalesStateCopyWith<$Res> {
  _$SalesStateCopyWithImpl(this._self, this._then);

  final SalesState _self;
  final $Res Function(SalesState) _then;

  /// Create a copy of SalesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cart = null,
    Object? sales = null,
    Object? orderId = freezed,
    Object? error = freezed,
    Object? selectedDate = freezed,
  }) {
    return _then(_self.copyWith(
      cart: null == cart
          ? _self.cart
          : cart // ignore: cast_nullable_to_non_nullable
              as CartModel,
      sales: null == sales
          ? _self.sales
          : sales // ignore: cast_nullable_to_non_nullable
              as List<SaleModel>,
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDate: freezed == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  /// Create a copy of SalesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartModelCopyWith<$Res> get cart {
    return $CartModelCopyWith<$Res>(_self.cart, (value) {
      return _then(_self.copyWith(cart: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _SalesState implements SalesState {
  const _SalesState(
      {required this.cart,
      required final List<SaleModel> sales,
      this.orderId,
      this.error,
      this.selectedDate})
      : _sales = sales;
  factory _SalesState.fromJson(Map<String, dynamic> json) =>
      _$SalesStateFromJson(json);

  @override
  final CartModel cart;
  final List<SaleModel> _sales;
  @override
  List<SaleModel> get sales {
    if (_sales is EqualUnmodifiableListView) return _sales;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sales);
  }

  @override
  final String? orderId;
  @override
  final String? error;
  @override
  final DateTime? selectedDate;

  /// Create a copy of SalesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SalesStateCopyWith<_SalesState> get copyWith =>
      __$SalesStateCopyWithImpl<_SalesState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SalesStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SalesState &&
            (identical(other.cart, cart) || other.cart == cart) &&
            const DeepCollectionEquality().equals(other._sales, _sales) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      cart,
      const DeepCollectionEquality().hash(_sales),
      orderId,
      error,
      selectedDate);

  @override
  String toString() {
    return 'SalesState(cart: $cart, sales: $sales, orderId: $orderId, error: $error, selectedDate: $selectedDate)';
  }
}

/// @nodoc
abstract mixin class _$SalesStateCopyWith<$Res>
    implements $SalesStateCopyWith<$Res> {
  factory _$SalesStateCopyWith(
          _SalesState value, $Res Function(_SalesState) _then) =
      __$SalesStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {CartModel cart,
      List<SaleModel> sales,
      String? orderId,
      String? error,
      DateTime? selectedDate});

  @override
  $CartModelCopyWith<$Res> get cart;
}

/// @nodoc
class __$SalesStateCopyWithImpl<$Res> implements _$SalesStateCopyWith<$Res> {
  __$SalesStateCopyWithImpl(this._self, this._then);

  final _SalesState _self;
  final $Res Function(_SalesState) _then;

  /// Create a copy of SalesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? cart = null,
    Object? sales = null,
    Object? orderId = freezed,
    Object? error = freezed,
    Object? selectedDate = freezed,
  }) {
    return _then(_SalesState(
      cart: null == cart
          ? _self.cart
          : cart // ignore: cast_nullable_to_non_nullable
              as CartModel,
      sales: null == sales
          ? _self._sales
          : sales // ignore: cast_nullable_to_non_nullable
              as List<SaleModel>,
      orderId: freezed == orderId
          ? _self.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDate: freezed == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  /// Create a copy of SalesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartModelCopyWith<$Res> get cart {
    return $CartModelCopyWith<$Res>(_self.cart, (value) {
      return _then(_self.copyWith(cart: value));
    });
  }
}

// dart format on
