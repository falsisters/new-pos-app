// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsState _$SettingsStateFromJson(Map<String, dynamic> json) =>
    _SettingsState(
      availablePrinters: (json['availablePrinters'] as List<dynamic>?)
              ?.map((e) => ThermalPrinter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selectedPrinter: json['selectedPrinter'] == null
          ? null
          : ThermalPrinter.fromJson(
              json['selectedPrinter'] as Map<String, dynamic>),
      isScanning: json['isScanning'] as bool? ?? false,
      isBluetoothEnabled: json['isBluetoothEnabled'] as bool? ?? false,
      printCopiesSetting: $enumDecodeNullable(
              _$PrintCopiesSettingEnumMap, json['printCopiesSetting']) ??
          PrintCopiesSetting.TWO_COPIES,
      isKioskModeEnabled: json['isKioskModeEnabled'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$SettingsStateToJson(_SettingsState instance) =>
    <String, dynamic>{
      'availablePrinters': instance.availablePrinters,
      'selectedPrinter': instance.selectedPrinter,
      'isScanning': instance.isScanning,
      'isBluetoothEnabled': instance.isBluetoothEnabled,
      'printCopiesSetting':
          _$PrintCopiesSettingEnumMap[instance.printCopiesSetting]!,
      'isKioskModeEnabled': instance.isKioskModeEnabled,
      'errorMessage': instance.errorMessage,
    };

const _$PrintCopiesSettingEnumMap = {
  PrintCopiesSetting.ONE_COPY: 'ONE_COPY',
  PrintCopiesSetting.TWO_COPIES: 'TWO_COPIES',
  PrintCopiesSetting.PROMPT_EVERY_SALE: 'PROMPT_EVERY_SALE',
};
