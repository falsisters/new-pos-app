// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShiftModel {
  String get id;
  List<EmployeeModel> get employees;
  DateTime get startTime;
  DateTime? get endTime;

  /// Create a copy of ShiftModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShiftModelCopyWith<ShiftModel> get copyWith =>
      _$ShiftModelCopyWithImpl<ShiftModel>(this as ShiftModel, _$identity);

  /// Serializes this ShiftModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShiftModel &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.employees, employees) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id,
      const DeepCollectionEquality().hash(employees), startTime, endTime);

  @override
  String toString() {
    return 'ShiftModel(id: $id, employees: $employees, startTime: $startTime, endTime: $endTime)';
  }
}

/// @nodoc
abstract mixin class $ShiftModelCopyWith<$Res> {
  factory $ShiftModelCopyWith(
          ShiftModel value, $Res Function(ShiftModel) _then) =
      _$ShiftModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      List<EmployeeModel> employees,
      DateTime startTime,
      DateTime? endTime});
}

/// @nodoc
class _$ShiftModelCopyWithImpl<$Res> implements $ShiftModelCopyWith<$Res> {
  _$ShiftModelCopyWithImpl(this._self, this._then);

  final ShiftModel _self;
  final $Res Function(ShiftModel) _then;

  /// Create a copy of ShiftModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employees = null,
    Object? startTime = null,
    Object? endTime = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employees: null == employees
          ? _self.employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeModel>,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ShiftModel implements ShiftModel {
  const _ShiftModel(
      {required this.id,
      required final List<EmployeeModel> employees,
      required this.startTime,
      required this.endTime})
      : _employees = employees;
  factory _ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);

  @override
  final String id;
  final List<EmployeeModel> _employees;
  @override
  List<EmployeeModel> get employees {
    if (_employees is EqualUnmodifiableListView) return _employees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employees);
  }

  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;

  /// Create a copy of ShiftModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ShiftModelCopyWith<_ShiftModel> get copyWith =>
      __$ShiftModelCopyWithImpl<_ShiftModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ShiftModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ShiftModel &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._employees, _employees) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id,
      const DeepCollectionEquality().hash(_employees), startTime, endTime);

  @override
  String toString() {
    return 'ShiftModel(id: $id, employees: $employees, startTime: $startTime, endTime: $endTime)';
  }
}

/// @nodoc
abstract mixin class _$ShiftModelCopyWith<$Res>
    implements $ShiftModelCopyWith<$Res> {
  factory _$ShiftModelCopyWith(
          _ShiftModel value, $Res Function(_ShiftModel) _then) =
      __$ShiftModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      List<EmployeeModel> employees,
      DateTime startTime,
      DateTime? endTime});
}

/// @nodoc
class __$ShiftModelCopyWithImpl<$Res> implements _$ShiftModelCopyWith<$Res> {
  __$ShiftModelCopyWithImpl(this._self, this._then);

  final _ShiftModel _self;
  final $Res Function(_ShiftModel) _then;

  /// Create a copy of ShiftModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? employees = null,
    Object? startTime = null,
    Object? endTime = freezed,
  }) {
    return _then(_ShiftModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      employees: null == employees
          ? _self._employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeModel>,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: freezed == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
