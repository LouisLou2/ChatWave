import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/*--------------------------event-----------------------------*/
sealed class ThemeEvent {
  const ThemeEvent();
}

class ToLightTheme extends ThemeEvent {
  const ToLightTheme();
}
class ToDarkTheme extends ThemeEvent {
  const ToDarkTheme();
}
/*--------------------------state-----------------------------*/
sealed class ThemeState extends Equatable{
  final ThemeMode mode;

  const ThemeState({required this.mode});

  @override
  List<Object?> get props => [mode];
}

class LightThemeState extends ThemeState {
  const LightThemeState() : super(mode: ThemeMode.light);
}

class DarkThemeState extends ThemeState {
  const DarkThemeState() : super(mode: ThemeMode.dark);
}
/*-----------------------bloc---------------------------------*/
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(super.initialState){
    on<ToLightTheme>((event, emit) {
      emit(const LightThemeState());
    });
    on<ToDarkTheme>((event, emit) {
      emit(const DarkThemeState());
    });
  }
}



