// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'printer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThermalPrinter {
  String get name;
  String get address;
  bool get isConnected;
  bool get isBonded;
  ConnectionType get connectionType;
  String? get vendorId;
  String? get productId;

  /// Create a copy of ThermalPrinter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThermalPrinterCopyWith<ThermalPrinter> get copyWith =>
      _$ThermalPrinterCopyWithImpl<ThermalPrinter>(
          this as ThermalPrinter, _$identity);

  /// Serializes this ThermalPrinter to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThermalPrinter &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.isBonded, isBonded) ||
                other.isBonded == isBonded) &&
            (identical(other.connectionType, connectionType) ||
                other.connectionType == connectionType) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, address, isConnected,
      isBonded, connectionType, vendorId, productId);

  @override
  String toString() {
    return 'ThermalPrinter(name: $name, address: $address, isConnected: $isConnected, isBonded: $isBonded, connectionType: $connectionType, vendorId: $vendorId, productId: $productId)';
  }
}

/// @nodoc
abstract mixin class $ThermalPrinterCopyWith<$Res> {
  factory $ThermalPrinterCopyWith(
          ThermalPrinter value, $Res Function(ThermalPrinter) _then) =
      _$ThermalPrinterCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      String address,
      bool isConnected,
      bool isBonded,
      ConnectionType connectionType,
      String? vendorId,
      String? productId});
}

/// @nodoc
class _$ThermalPrinterCopyWithImpl<$Res>
    implements $ThermalPrinterCopyWith<$Res> {
  _$ThermalPrinterCopyWithImpl(this._self, this._then);

  final ThermalPrinter _self;
  final $Res Function(ThermalPrinter) _then;

  /// Create a copy of ThermalPrinter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? address = null,
    Object? isConnected = null,
    Object? isBonded = null,
    Object? connectionType = null,
    Object? vendorId = freezed,
    Object? productId = freezed,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      isConnected: null == isConnected
          ? _self.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      isBonded: null == isBonded
          ? _self.isBonded
          : isBonded // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionType: null == connectionType
          ? _self.connectionType
          : connectionType // ignore: cast_nullable_to_non_nullable
              as ConnectionType,
      vendorId: freezed == vendorId
          ? _self.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ThermalPrinter extends ThermalPrinter {
  const _ThermalPrinter(
      {required this.name,
      required this.address,
      this.isConnected = false,
      this.isBonded = false,
      this.connectionType = ConnectionType.BLE,
      this.vendorId,
      this.productId})
      : super._();
  factory _ThermalPrinter.fromJson(Map<String, dynamic> json) =>
      _$ThermalPrinterFromJson(json);

  @override
  final String name;
  @override
  final String address;
  @override
  @JsonKey()
  final bool isConnected;
  @override
  @JsonKey()
  final bool isBonded;
  @override
  @JsonKey()
  final ConnectionType connectionType;
  @override
  final String? vendorId;
  @override
  final String? productId;

  /// Create a copy of ThermalPrinter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ThermalPrinterCopyWith<_ThermalPrinter> get copyWith =>
      __$ThermalPrinterCopyWithImpl<_ThermalPrinter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ThermalPrinterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ThermalPrinter &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.isBonded, isBonded) ||
                other.isBonded == isBonded) &&
            (identical(other.connectionType, connectionType) ||
                other.connectionType == connectionType) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.productId, productId) ||
                other.productId == productId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, address, isConnected,
      isBonded, connectionType, vendorId, productId);

  @override
  String toString() {
    return 'ThermalPrinter(name: $name, address: $address, isConnected: $isConnected, isBonded: $isBonded, connectionType: $connectionType, vendorId: $vendorId, productId: $productId)';
  }
}

/// @nodoc
abstract mixin class _$ThermalPrinterCopyWith<$Res>
    implements $ThermalPrinterCopyWith<$Res> {
  factory _$ThermalPrinterCopyWith(
          _ThermalPrinter value, $Res Function(_ThermalPrinter) _then) =
      __$ThermalPrinterCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      String address,
      bool isConnected,
      bool isBonded,
      ConnectionType connectionType,
      String? vendorId,
      String? productId});
}

/// @nodoc
class __$ThermalPrinterCopyWithImpl<$Res>
    implements _$ThermalPrinterCopyWith<$Res> {
  __$ThermalPrinterCopyWithImpl(this._self, this._then);

  final _ThermalPrinter _self;
  final $Res Function(_ThermalPrinter) _then;

  /// Create a copy of ThermalPrinter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? address = null,
    Object? isConnected = null,
    Object? isBonded = null,
    Object? connectionType = null,
    Object? vendorId = freezed,
    Object? productId = freezed,
  }) {
    return _then(_ThermalPrinter(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      isConnected: null == isConnected
          ? _self.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      isBonded: null == isBonded
          ? _self.isBonded
          : isBonded // ignore: cast_nullable_to_non_nullable
              as bool,
      connectionType: null == connectionType
          ? _self.connectionType
          : connectionType // ignore: cast_nullable_to_non_nullable
              as ConnectionType,
      vendorId: freezed == vendorId
          ? _self.vendorId
          : vendorId // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _self.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
