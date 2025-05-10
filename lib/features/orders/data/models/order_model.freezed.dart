// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderModel implements DiagnosticableTreeMixin {
  String get id;
  double get totalPrice;
  String get userId;
  CustomerModel get customer;
  String get customerId;
  @JsonKey(defaultValue: OrderStatus.pending)
  OrderStatus get status;
  String? get saleId;
  @JsonKey(name: 'OrderItem')
  List<OrderItemModel> get orderItems;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderModelCopyWith<OrderModel> get copyWith =>
      _$OrderModelCopyWithImpl<OrderModel>(this as OrderModel, _$identity);

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'OrderModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('totalPrice', totalPrice))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('customer', customer))
      ..add(DiagnosticsProperty('customerId', customerId))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('saleId', saleId))
      ..add(DiagnosticsProperty('orderItems', orderItems))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.saleId, saleId) || other.saleId == saleId) &&
            const DeepCollectionEquality()
                .equals(other.orderItems, orderItems) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      totalPrice,
      userId,
      customer,
      customerId,
      status,
      saleId,
      const DeepCollectionEquality().hash(orderItems),
      createdAt,
      updatedAt);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderModel(id: $id, totalPrice: $totalPrice, userId: $userId, customer: $customer, customerId: $customerId, status: $status, saleId: $saleId, orderItems: $orderItems, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) _then) =
      _$OrderModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      double totalPrice,
      String userId,
      CustomerModel customer,
      String customerId,
      @JsonKey(defaultValue: OrderStatus.pending) OrderStatus status,
      String? saleId,
      @JsonKey(name: 'OrderItem') List<OrderItemModel> orderItems,
      DateTime createdAt,
      DateTime updatedAt});

  $CustomerModelCopyWith<$Res> get customer;
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res> implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._self, this._then);

  final OrderModel _self;
  final $Res Function(OrderModel) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? totalPrice = null,
    Object? userId = null,
    Object? customer = null,
    Object? customerId = null,
    Object? status = null,
    Object? saleId = freezed,
    Object? orderItems = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      totalPrice: null == totalPrice
          ? _self.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      customer: null == customer
          ? _self.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerModel,
      customerId: null == customerId
          ? _self.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      saleId: freezed == saleId
          ? _self.saleId
          : saleId // ignore: cast_nullable_to_non_nullable
              as String?,
      orderItems: null == orderItems
          ? _self.orderItems
          : orderItems // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerModelCopyWith<$Res> get customer {
    return $CustomerModelCopyWith<$Res>(_self.customer, (value) {
      return _then(_self.copyWith(customer: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _OrderModel with DiagnosticableTreeMixin implements OrderModel {
  const _OrderModel(
      {required this.id,
      required this.totalPrice,
      required this.userId,
      required this.customer,
      required this.customerId,
      @JsonKey(defaultValue: OrderStatus.pending) required this.status,
      this.saleId,
      @JsonKey(name: 'OrderItem')
      final List<OrderItemModel> orderItems = const [],
      required this.createdAt,
      required this.updatedAt})
      : _orderItems = orderItems;
  factory _OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  @override
  final String id;
  @override
  final double totalPrice;
  @override
  final String userId;
  @override
  final CustomerModel customer;
  @override
  final String customerId;
  @override
  @JsonKey(defaultValue: OrderStatus.pending)
  final OrderStatus status;
  @override
  final String? saleId;
  final List<OrderItemModel> _orderItems;
  @override
  @JsonKey(name: 'OrderItem')
  List<OrderItemModel> get orderItems {
    if (_orderItems is EqualUnmodifiableListView) return _orderItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderItems);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderModelCopyWith<_OrderModel> get copyWith =>
      __$OrderModelCopyWithImpl<_OrderModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OrderModelToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'OrderModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('totalPrice', totalPrice))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('customer', customer))
      ..add(DiagnosticsProperty('customerId', customerId))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('saleId', saleId))
      ..add(DiagnosticsProperty('orderItems', orderItems))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.saleId, saleId) || other.saleId == saleId) &&
            const DeepCollectionEquality()
                .equals(other._orderItems, _orderItems) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      totalPrice,
      userId,
      customer,
      customerId,
      status,
      saleId,
      const DeepCollectionEquality().hash(_orderItems),
      createdAt,
      updatedAt);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderModel(id: $id, totalPrice: $totalPrice, userId: $userId, customer: $customer, customerId: $customerId, status: $status, saleId: $saleId, orderItems: $orderItems, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$OrderModelCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$OrderModelCopyWith(
          _OrderModel value, $Res Function(_OrderModel) _then) =
      __$OrderModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      double totalPrice,
      String userId,
      CustomerModel customer,
      String customerId,
      @JsonKey(defaultValue: OrderStatus.pending) OrderStatus status,
      String? saleId,
      @JsonKey(name: 'OrderItem') List<OrderItemModel> orderItems,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $CustomerModelCopyWith<$Res> get customer;
}

/// @nodoc
class __$OrderModelCopyWithImpl<$Res> implements _$OrderModelCopyWith<$Res> {
  __$OrderModelCopyWithImpl(this._self, this._then);

  final _OrderModel _self;
  final $Res Function(_OrderModel) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? totalPrice = null,
    Object? userId = null,
    Object? customer = null,
    Object? customerId = null,
    Object? status = null,
    Object? saleId = freezed,
    Object? orderItems = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_OrderModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      totalPrice: null == totalPrice
          ? _self.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      customer: null == customer
          ? _self.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerModel,
      customerId: null == customerId
          ? _self.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      saleId: freezed == saleId
          ? _self.saleId
          : saleId // ignore: cast_nullable_to_non_nullable
              as String?,
      orderItems: null == orderItems
          ? _self._orderItems
          : orderItems // ignore: cast_nullable_to_non_nullable
              as List<OrderItemModel>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerModelCopyWith<$Res> get customer {
    return $CustomerModelCopyWith<$Res>(_self.customer, (value) {
      return _then(_self.copyWith(customer: value));
    });
  }
}

// dart format on
