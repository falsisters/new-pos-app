// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_sack_price_dto_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliverySackPriceDtoModel {
  String get id;
  SackType get type;
  double get quantity;

  /// Create a copy of DeliverySackPriceDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeliverySackPriceDtoModelCopyWith<DeliverySackPriceDtoModel> get copyWith =>
      _$DeliverySackPriceDtoModelCopyWithImpl<DeliverySackPriceDtoModel>(
          this as DeliverySackPriceDtoModel, _$identity);

  /// Serializes this DeliverySackPriceDtoModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeliverySackPriceDtoModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, quantity);

  @override
  String toString() {
    return 'DeliverySackPriceDtoModel(id: $id, type: $type, quantity: $quantity)';
  }
}

/// @nodoc
abstract mixin class $DeliverySackPriceDtoModelCopyWith<$Res> {
  factory $DeliverySackPriceDtoModelCopyWith(DeliverySackPriceDtoModel value,
          $Res Function(DeliverySackPriceDtoModel) _then) =
      _$DeliverySackPriceDtoModelCopyWithImpl;
  @useResult
  $Res call({String id, SackType type, double quantity});
}

/// @nodoc
class _$DeliverySackPriceDtoModelCopyWithImpl<$Res>
    implements $DeliverySackPriceDtoModelCopyWith<$Res> {
  _$DeliverySackPriceDtoModelCopyWithImpl(this._self, this._then);

  final DeliverySackPriceDtoModel _self;
  final $Res Function(DeliverySackPriceDtoModel) _then;

  /// Create a copy of DeliverySackPriceDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? quantity = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as SackType,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _DeliverySackPriceDtoModel implements DeliverySackPriceDtoModel {
  const _DeliverySackPriceDtoModel(
      {required this.id, required this.type, required this.quantity});
  factory _DeliverySackPriceDtoModel.fromJson(Map<String, dynamic> json) =>
      _$DeliverySackPriceDtoModelFromJson(json);

  @override
  final String id;
  @override
  final SackType type;
  @override
  final double quantity;

  /// Create a copy of DeliverySackPriceDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DeliverySackPriceDtoModelCopyWith<_DeliverySackPriceDtoModel>
      get copyWith =>
          __$DeliverySackPriceDtoModelCopyWithImpl<_DeliverySackPriceDtoModel>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DeliverySackPriceDtoModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeliverySackPriceDtoModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, quantity);

  @override
  String toString() {
    return 'DeliverySackPriceDtoModel(id: $id, type: $type, quantity: $quantity)';
  }
}

/// @nodoc
abstract mixin class _$DeliverySackPriceDtoModelCopyWith<$Res>
    implements $DeliverySackPriceDtoModelCopyWith<$Res> {
  factory _$DeliverySackPriceDtoModelCopyWith(_DeliverySackPriceDtoModel value,
          $Res Function(_DeliverySackPriceDtoModel) _then) =
      __$DeliverySackPriceDtoModelCopyWithImpl;
  @override
  @useResult
  $Res call({String id, SackType type, double quantity});
}

/// @nodoc
class __$DeliverySackPriceDtoModelCopyWithImpl<$Res>
    implements _$DeliverySackPriceDtoModelCopyWith<$Res> {
  __$DeliverySackPriceDtoModelCopyWithImpl(this._self, this._then);

  final _DeliverySackPriceDtoModel _self;
  final $Res Function(_DeliverySackPriceDtoModel) _then;

  /// Create a copy of DeliverySackPriceDtoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? quantity = null,
  }) {
    return _then(_DeliverySackPriceDtoModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as SackType,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
