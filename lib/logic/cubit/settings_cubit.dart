import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wakelock/wakelock.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  void toggleScreenWake() {
    bool toggled = !this.state.screenWakeLocked;
    Wakelock.toggle(enable: toggled);
    emit(this.state.copyWith(screenWakeLocked: toggled));
  }
}
