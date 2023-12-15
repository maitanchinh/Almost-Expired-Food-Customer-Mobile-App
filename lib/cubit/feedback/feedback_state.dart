class FeedbackState {}

class FeedbackLoadingState extends FeedbackState {}

class FeedbackFailedState extends FeedbackState {
  final String msg;
  FeedbackFailedState({required this.msg});
}

class FeedbackSuccessState extends FeedbackState {
  final int statusCode;
  FeedbackSuccessState({required this.statusCode});
}
