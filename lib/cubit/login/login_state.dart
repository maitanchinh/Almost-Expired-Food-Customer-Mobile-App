class LoginByGoogleState {}

class LoginByGooglelLoadingState extends LoginByGoogleState {}

class LoginByGooglelFailedState extends LoginByGoogleState {
  final String message;

  LoginByGooglelFailedState({required this.message});
}

class LoginByGooglelSuccessState extends LoginByGoogleState {}
