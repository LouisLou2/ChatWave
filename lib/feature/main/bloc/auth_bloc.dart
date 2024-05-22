/*---------------event------------------*/
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class AuthEvent {}

class ToCheckLogState extends AuthEvent {}
class ToLogIn extends AuthEvent {}
class ToLogOut extends AuthEvent {}

/*---------------state------------------*/
sealed class AuthState extends Equatable {
  final int stateCode;
  const AuthState({required this.stateCode});
}

class CheckingAuthState extends AuthState {
  const CheckingAuthState() : super(stateCode: 0);

  @override
  List<Object?> get props => [stateCode];
}

class LoggedInState extends AuthState {
  const LoggedInState() : super(stateCode: 1);

  @override
  List<Object?> get props => [stateCode];
}

class NotLoggedInState extends AuthState {
  const NotLoggedInState() : super(stateCode: 2);

  @override
  List<Object?> get props => [stateCode];
}

/*---------------bloc------------------*/
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(super.initialState){
    on<ToCheckLogState>( _checkLogState );
    on<ToLogIn>( _logIn );
    on<ToLogOut>( _logOut );
  }

  void _checkLogState(ToCheckLogState event, Emitter<AuthState> emit) {
    //TODO
    // if 成功: add(ToLogIn());
    // else: add(ToLogOut());
  }

  void _logIn(ToLogIn event, Emitter<AuthState> emit) {
    //TODO
    // if 成功: add(ToLogIn());
    // else: add(ToLogOut());
  }

  void _logOut(ToLogOut event, Emitter<AuthState> emit) {
    //TODO
    // if 成功: add(ToLogOut());
    // else: add(ToLogIn());
  }
}