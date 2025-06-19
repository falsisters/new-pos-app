// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_sale.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingSale {
  String get id;
  CreateSaleRequestModel get saleRequest;
  DateTime get timestamp;
  bool get isProcessing;
  String? get error;

  /// Create a copy of PendingSale
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PendingSaleCopyWith<PendingSale> get copyWith =>
      _$PendingSaleCopyWithImpl<PendingSale>(this as PendingSale, _$identity);

  /// Serializes this PendingSale to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PendingSale &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.saleRequest, saleRequest) ||
                other.saleRequest == saleRequest) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, saleRequest, timestamp, isProcessing, error);

  @override
  String toString() {
    return 'PendingSale(id: $id, saleRequest: $saleRequest, timestamp: $timestamp, isProcessing: $isProcessing, error: $error)';
  }
}

/// @nodoc
abstract mixin class $PendingSaleCopyWith<$Res> {
  factory $PendingSaleCopyWith(
          PendingSale value, $Res Function(PendingSale) _then) =
      _$PendingSaleCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      CreateSaleRequestModel saleRequest,
      DateTime timestamp,
      bool isProcessing,
      String? error});

  $CreateSaleRequestModelCopyWith<$Res> get saleRequest;
}

/// @nodoc
class _$PendingSaleCopyWithImpl<$Res> implements $PendingSaleCopyWith<$Res> {
  _$PendingSaleCopyWithImpl(this._self, this._then);

  final PendingSale _self;
  final $Res Function(PendingSale) _then;

  /// Create a copy of PendingSale
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? saleRequest = null,
    Object? timestamp = null,
    Object? isProcessing = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      saleRequest: null == saleRequest
          ? _self.saleRequest
          : saleRequest // ignore: cast_nullable_to_non_nullable
              as CreateSaleRequestModel,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of PendingSale
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreateSaleRequestModelCopyWith<$Res> get saleRequest {
    return $CreateSaleRequestModelCopyWith<$Res>(_self.saleRequest, (value) {
      return _then(_self.copyWith(saleRequest: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _PendingSale implements PendingSale {
  const _PendingSale(
      {required this.id,
      required this.saleRequest,
      required this.timestamp,
      this.isProcessing = false,
      this.error});
  factory _PendingSale.fromJson(Map<String, dynamic> json) =>
      _$PendingSaleFromJson(json);

  @override
  final String id;
  @override
  final CreateSaleRequestModel saleRequest;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool isProcessing;
  @override
  final String? error;

  /// Create a copy of PendingSale
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PendingSaleCopyWith<_PendingSale> get copyWith =>
      __$PendingSaleCopyWithImpl<_PendingSale>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PendingSaleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PendingSale &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.saleRequest, saleRequest) ||
                other.saleRequest == saleRequest) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isProcessing, isProcessing) ||
                other.isProcessing == isProcessing) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, saleRequest, timestamp, isProcessing, error);

  @override
  String toString() {
    return 'PendingSale(id: $id, saleRequest: $saleRequest, timestamp: $timestamp, isProcessing: $isProcessing, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$PendingSaleCopyWith<$Res>
    implements $PendingSaleCopyWith<$Res> {
  factory _$PendingSaleCopyWith(
          _PendingSale value, $Res Function(_PendingSale) _then) =
      __$PendingSaleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      CreateSaleRequestModel saleRequest,
      DateTime timestamp,
      bool isProcessing,
      String? error});

  @override
  $CreateSaleRequestModelCopyWith<$Res> get saleRequest;
}

/// @nodoc
class __$PendingSaleCopyWithImpl<$Res> implements _$PendingSaleCopyWith<$Res> {
  __$PendingSaleCopyWithImpl(this._self, this._then);

  final _PendingSale _self;
  final $Res Function(_PendingSale) _then;

  /// Create a copy of PendingSale
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? saleRequest = null,
    Object? timestamp = null,
    Object? isProcessing = null,
    Object? error = freezed,
  }) {
    return _then(_PendingSale(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      saleRequest: null == saleRequest
          ? _self.saleRequest
          : saleRequest // ignore: cast_nullable_to_non_nullable
              as CreateSaleRequestModel,
      timestamp: null == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isProcessing: null == isProcessing
          ? _self.isProcessing
          : isProcessing // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of PendingSale
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CreateSaleRequestModelCopyWith<$Res> get saleRequest {
    return $CreateSaleRequestModelCopyWith<$Res>(_self.saleRequest, (value) {
      return _then(_self.copyWith(saleRequest: value));
    });
  }
}

// dart format on
