// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsState {
  List<ThermalPrinter> get availablePrinters;
  ThermalPrinter? get selectedPrinter;
  bool get isScanning;
  bool get isBluetoothEnabled;
  PrintCopiesSetting get printCopiesSetting;
  String? get errorMessage;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SettingsStateCopyWith<SettingsState> get copyWith =>
      _$SettingsStateCopyWithImpl<SettingsState>(
          this as SettingsState, _$identity);

  /// Serializes this SettingsState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SettingsState &&
            const DeepCollectionEquality()
                .equals(other.availablePrinters, availablePrinters) &&
            (identical(other.selectedPrinter, selectedPrinter) ||
                other.selectedPrinter == selectedPrinter) &&
            (identical(other.isScanning, isScanning) ||
                other.isScanning == isScanning) &&
            (identical(other.isBluetoothEnabled, isBluetoothEnabled) ||
                other.isBluetoothEnabled == isBluetoothEnabled) &&
            (identical(other.printCopiesSetting, printCopiesSetting) ||
                other.printCopiesSetting == printCopiesSetting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(availablePrinters),
      selectedPrinter,
      isScanning,
      isBluetoothEnabled,
      printCopiesSetting,
      errorMessage);

  @override
  String toString() {
    return 'SettingsState(availablePrinters: $availablePrinters, selectedPrinter: $selectedPrinter, isScanning: $isScanning, isBluetoothEnabled: $isBluetoothEnabled, printCopiesSetting: $printCopiesSetting, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(
          SettingsState value, $Res Function(SettingsState) _then) =
      _$SettingsStateCopyWithImpl;
  @useResult
  $Res call(
      {List<ThermalPrinter> availablePrinters,
      ThermalPrinter? selectedPrinter,
      bool isScanning,
      bool isBluetoothEnabled,
      PrintCopiesSetting printCopiesSetting,
      String? errorMessage});

  $ThermalPrinterCopyWith<$Res>? get selectedPrinter;
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? availablePrinters = null,
    Object? selectedPrinter = freezed,
    Object? isScanning = null,
    Object? isBluetoothEnabled = null,
    Object? printCopiesSetting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      availablePrinters: null == availablePrinters
          ? _self.availablePrinters
          : availablePrinters // ignore: cast_nullable_to_non_nullable
              as List<ThermalPrinter>,
      selectedPrinter: freezed == selectedPrinter
          ? _self.selectedPrinter
          : selectedPrinter // ignore: cast_nullable_to_non_nullable
              as ThermalPrinter?,
      isScanning: null == isScanning
          ? _self.isScanning
          : isScanning // ignore: cast_nullable_to_non_nullable
              as bool,
      isBluetoothEnabled: null == isBluetoothEnabled
          ? _self.isBluetoothEnabled
          : isBluetoothEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      printCopiesSetting: null == printCopiesSetting
          ? _self.printCopiesSetting
          : printCopiesSetting // ignore: cast_nullable_to_non_nullable
              as PrintCopiesSetting,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ThermalPrinterCopyWith<$Res>? get selectedPrinter {
    if (_self.selectedPrinter == null) {
      return null;
    }

    return $ThermalPrinterCopyWith<$Res>(_self.selectedPrinter!, (value) {
      return _then(_self.copyWith(selectedPrinter: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _SettingsState implements SettingsState {
  const _SettingsState(
      {final List<ThermalPrinter> availablePrinters = const [],
      this.selectedPrinter,
      this.isScanning = false,
      this.isBluetoothEnabled = false,
      this.printCopiesSetting = PrintCopiesSetting.TWO_COPIES,
      this.errorMessage})
      : _availablePrinters = availablePrinters;
  factory _SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);

  final List<ThermalPrinter> _availablePrinters;
  @override
  @JsonKey()
  List<ThermalPrinter> get availablePrinters {
    if (_availablePrinters is EqualUnmodifiableListView)
      return _availablePrinters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availablePrinters);
  }

  @override
  final ThermalPrinter? selectedPrinter;
  @override
  @JsonKey()
  final bool isScanning;
  @override
  @JsonKey()
  final bool isBluetoothEnabled;
  @override
  @JsonKey()
  final PrintCopiesSetting printCopiesSetting;
  @override
  final String? errorMessage;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SettingsStateCopyWith<_SettingsState> get copyWith =>
      __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SettingsStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SettingsState &&
            const DeepCollectionEquality()
                .equals(other._availablePrinters, _availablePrinters) &&
            (identical(other.selectedPrinter, selectedPrinter) ||
                other.selectedPrinter == selectedPrinter) &&
            (identical(other.isScanning, isScanning) ||
                other.isScanning == isScanning) &&
            (identical(other.isBluetoothEnabled, isBluetoothEnabled) ||
                other.isBluetoothEnabled == isBluetoothEnabled) &&
            (identical(other.printCopiesSetting, printCopiesSetting) ||
                other.printCopiesSetting == printCopiesSetting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_availablePrinters),
      selectedPrinter,
      isScanning,
      isBluetoothEnabled,
      printCopiesSetting,
      errorMessage);

  @override
  String toString() {
    return 'SettingsState(availablePrinters: $availablePrinters, selectedPrinter: $selectedPrinter, isScanning: $isScanning, isBluetoothEnabled: $isBluetoothEnabled, printCopiesSetting: $printCopiesSetting, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res>
    implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(
          _SettingsState value, $Res Function(_SettingsState) _then) =
      __$SettingsStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<ThermalPrinter> availablePrinters,
      ThermalPrinter? selectedPrinter,
      bool isScanning,
      bool isBluetoothEnabled,
      PrintCopiesSetting printCopiesSetting,
      String? errorMessage});

  @override
  $ThermalPrinterCopyWith<$Res>? get selectedPrinter;
}

/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? availablePrinters = null,
    Object? selectedPrinter = freezed,
    Object? isScanning = null,
    Object? isBluetoothEnabled = null,
    Object? printCopiesSetting = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_SettingsState(
      availablePrinters: null == availablePrinters
          ? _self._availablePrinters
          : availablePrinters // ignore: cast_nullable_to_non_nullable
              as List<ThermalPrinter>,
      selectedPrinter: freezed == selectedPrinter
          ? _self.selectedPrinter
          : selectedPrinter // ignore: cast_nullable_to_non_nullable
              as ThermalPrinter?,
      isScanning: null == isScanning
          ? _self.isScanning
          : isScanning // ignore: cast_nullable_to_non_nullable
              as bool,
      isBluetoothEnabled: null == isBluetoothEnabled
          ? _self.isBluetoothEnabled
          : isBluetoothEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      printCopiesSetting: null == printCopiesSetting
          ? _self.printCopiesSetting
          : printCopiesSetting // ignore: cast_nullable_to_non_nullable
              as PrintCopiesSetting,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ThermalPrinterCopyWith<$Res>? get selectedPrinter {
    if (_self.selectedPrinter == null) {
      return null;
    }

    return $ThermalPrinterCopyWith<$Res>(_self.selectedPrinter!, (value) {
      return _then(_self.copyWith(selectedPrinter: value));
    });
  }
}

// dart format on
