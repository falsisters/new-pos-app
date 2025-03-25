// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_sack_price_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditSackPriceRequestModel {
  List<EditSackPriceDto> get sackPrice;

  /// Create a copy of EditSackPriceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EditSackPriceRequestModelCopyWith<EditSackPriceRequestModel> get copyWith =>
      _$EditSackPriceRequestModelCopyWithImpl<EditSackPriceRequestModel>(
          this as EditSackPriceRequestModel, _$identity);

  /// Serializes this EditSackPriceRequestModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EditSackPriceRequestModel &&
            const DeepCollectionEquality().equals(other.sackPrice, sackPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(sackPrice));

  @override
  String toString() {
    return 'EditSackPriceRequestModel(sackPrice: $sackPrice)';
  }
}

/// @nodoc
abstract mixin class $EditSackPriceRequestModelCopyWith<$Res> {
  factory $EditSackPriceRequestModelCopyWith(EditSackPriceRequestModel value,
          $Res Function(EditSackPriceRequestModel) _then) =
      _$EditSackPriceRequestModelCopyWithImpl;
  @useResult
  $Res call({List<EditSackPriceDto> sackPrice});
}

/// @nodoc
class _$EditSackPriceRequestModelCopyWithImpl<$Res>
    implements $EditSackPriceRequestModelCopyWith<$Res> {
  _$EditSackPriceRequestModelCopyWithImpl(this._self, this._then);

  final EditSackPriceRequestModel _self;
  final $Res Function(EditSackPriceRequestModel) _then;

  /// Create a copy of EditSackPriceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sackPrice = null,
  }) {
    return _then(_self.copyWith(
      sackPrice: null == sackPrice
          ? _self.sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as List<EditSackPriceDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _EditSackPriceRequestModel implements EditSackPriceRequestModel {
  const _EditSackPriceRequestModel(
      {required final List<EditSackPriceDto> sackPrice})
      : _sackPrice = sackPrice;
  factory _EditSackPriceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EditSackPriceRequestModelFromJson(json);

  final List<EditSackPriceDto> _sackPrice;
  @override
  List<EditSackPriceDto> get sackPrice {
    if (_sackPrice is EqualUnmodifiableListView) return _sackPrice;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sackPrice);
  }

  /// Create a copy of EditSackPriceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EditSackPriceRequestModelCopyWith<_EditSackPriceRequestModel>
      get copyWith =>
          __$EditSackPriceRequestModelCopyWithImpl<_EditSackPriceRequestModel>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EditSackPriceRequestModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EditSackPriceRequestModel &&
            const DeepCollectionEquality()
                .equals(other._sackPrice, _sackPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_sackPrice));

  @override
  String toString() {
    return 'EditSackPriceRequestModel(sackPrice: $sackPrice)';
  }
}

/// @nodoc
abstract mixin class _$EditSackPriceRequestModelCopyWith<$Res>
    implements $EditSackPriceRequestModelCopyWith<$Res> {
  factory _$EditSackPriceRequestModelCopyWith(_EditSackPriceRequestModel value,
          $Res Function(_EditSackPriceRequestModel) _then) =
      __$EditSackPriceRequestModelCopyWithImpl;
  @override
  @useResult
  $Res call({List<EditSackPriceDto> sackPrice});
}

/// @nodoc
class __$EditSackPriceRequestModelCopyWithImpl<$Res>
    implements _$EditSackPriceRequestModelCopyWith<$Res> {
  __$EditSackPriceRequestModelCopyWithImpl(this._self, this._then);

  final _EditSackPriceRequestModel _self;
  final $Res Function(_EditSackPriceRequestModel) _then;

  /// Create a copy of EditSackPriceRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sackPrice = null,
  }) {
    return _then(_EditSackPriceRequestModel(
      sackPrice: null == sackPrice
          ? _self._sackPrice
          : sackPrice // ignore: cast_nullable_to_non_nullable
              as List<EditSackPriceDto>,
    ));
  }
}

// dart format on
