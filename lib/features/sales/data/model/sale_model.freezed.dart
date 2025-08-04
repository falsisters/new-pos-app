// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sale_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaleModel {
  String get id;
  String get cashierId;
  @DecimalConverter()
  Decimal get totalAmount;
  PaymentMethod get paymentMethod;
  @JsonKey(name: 'SaleItem')
  List<SaleItem> get saleItems;
  String get createdAt;
  String get updatedAt;
  Map<String, dynamic>? get metadata;

  /// Create a copy of SaleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SaleModelCopyWith<SaleModel> get copyWith =>
      _$SaleModelCopyWithImpl<SaleModel>(this as SaleModel, _$identity);

  /// Serializes this SaleModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SaleModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            const DeepCollectionEquality().equals(other.saleItems, saleItems) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.metadata, metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      cashierId,
      totalAmount,
      paymentMethod,
      const DeepCollectionEquality().hash(saleItems),
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(metadata));

  @override
  String toString() {
    return 'SaleModel(id: $id, cashierId: $cashierId, totalAmount: $totalAmount, paymentMethod: $paymentMethod, saleItems: $saleItems, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class $SaleModelCopyWith<$Res> {
  factory $SaleModelCopyWith(SaleModel value, $Res Function(SaleModel) _then) =
      _$SaleModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String cashierId,
      @DecimalConverter() Decimal totalAmount,
      PaymentMethod paymentMethod,
      @JsonKey(name: 'SaleItem') List<SaleItem> saleItems,
      String createdAt,
      String updatedAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$SaleModelCopyWithImpl<$Res> implements $SaleModelCopyWith<$Res> {
  _$SaleModelCopyWithImpl(this._self, this._then);

  final SaleModel _self;
  final $Res Function(SaleModel) _then;

  /// Create a copy of SaleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cashierId = null,
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? saleItems = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? metadata = freezed,
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
              as Decimal,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      saleItems: null == saleItems
          ? _self.saleItems
          : saleItems // ignore: cast_nullable_to_non_nullable
              as List<SaleItem>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SaleModel implements SaleModel {
  const _SaleModel(
      {required this.id,
      required this.cashierId,
      @DecimalConverter() required this.totalAmount,
      required this.paymentMethod,
      @JsonKey(name: 'SaleItem') final List<SaleItem> saleItems = const [],
      required this.createdAt,
      required this.updatedAt,
      final Map<String, dynamic>? metadata})
      : _saleItems = saleItems,
        _metadata = metadata;
  factory _SaleModel.fromJson(Map<String, dynamic> json) =>
      _$SaleModelFromJson(json);

  @override
  final String id;
  @override
  final String cashierId;
  @override
  @DecimalConverter()
  final Decimal totalAmount;
  @override
  final PaymentMethod paymentMethod;
  final List<SaleItem> _saleItems;
  @override
  @JsonKey(name: 'SaleItem')
  List<SaleItem> get saleItems {
    if (_saleItems is EqualUnmodifiableListView) return _saleItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_saleItems);
  }

  @override
  final String createdAt;
  @override
  final String updatedAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of SaleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SaleModelCopyWith<_SaleModel> get copyWith =>
      __$SaleModelCopyWithImpl<_SaleModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SaleModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SaleModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.cashierId, cashierId) ||
                other.cashierId == cashierId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            const DeepCollectionEquality()
                .equals(other._saleItems, _saleItems) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      cashierId,
      totalAmount,
      paymentMethod,
      const DeepCollectionEquality().hash(_saleItems),
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_metadata));

  @override
  String toString() {
    return 'SaleModel(id: $id, cashierId: $cashierId, totalAmount: $totalAmount, paymentMethod: $paymentMethod, saleItems: $saleItems, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class _$SaleModelCopyWith<$Res>
    implements $SaleModelCopyWith<$Res> {
  factory _$SaleModelCopyWith(
          _SaleModel value, $Res Function(_SaleModel) _then) =
      __$SaleModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String cashierId,
      @DecimalConverter() Decimal totalAmount,
      PaymentMethod paymentMethod,
      @JsonKey(name: 'SaleItem') List<SaleItem> saleItems,
      String createdAt,
      String updatedAt,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$SaleModelCopyWithImpl<$Res> implements _$SaleModelCopyWith<$Res> {
  __$SaleModelCopyWithImpl(this._self, this._then);

  final _SaleModel _self;
  final $Res Function(_SaleModel) _then;

  /// Create a copy of SaleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? cashierId = null,
    Object? totalAmount = null,
    Object? paymentMethod = null,
    Object? saleItems = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? metadata = freezed,
  }) {
    return _then(_SaleModel(
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
              as Decimal,
      paymentMethod: null == paymentMethod
          ? _self.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      saleItems: null == saleItems
          ? _self._saleItems
          : saleItems // ignore: cast_nullable_to_non_nullable
              as List<SaleItem>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _self._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

// dart format on
