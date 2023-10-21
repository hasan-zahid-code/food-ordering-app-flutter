// lib/blocs/login/login_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  const LoginButtonPressed({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

// States
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailureState extends LoginState {
  final String error;

  const LoginFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoadingState();

      // Simulate an API call for authentication
      await Future.delayed(Duration(seconds: 2));

      // Replace this with your actual authentication logic
      if (event.username == 'hasan' && event.password == 'hasan') {
        yield LoginSuccessState();
      } else {
        yield LoginFailureState(error: 'Invalid credentials');
      }
    }
  }
}
