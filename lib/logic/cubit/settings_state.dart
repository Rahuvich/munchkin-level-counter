part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool screenWakeLocked;
  const SettingsState({this.screenWakeLocked = false});

  @override
  List<Object> get props => [screenWakeLocked];

  SettingsState copyWith({
    bool screenWakeLocked,
  }) {
    return SettingsState(
      screenWakeLocked: screenWakeLocked ?? this.screenWakeLocked,
    );
  }

  @override
  bool get stringify => true;
}
