import 'package:appetit/cubit/feedback/feedback_state.dart';
import 'package:appetit/domain/repositories/feedback_repo.dart';
import 'package:appetit/utils/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() :super(FeedbackState());
  final FeedbackRepo _feedbackRepo = getIt.get<FeedbackRepo>();

  Future<void> feedback({required String productId, required int star, String? message}) async {
    try {
      emit(FeedbackLoadingState());
      var statusCode = await _feedbackRepo.feedback(star: star, productId: productId, message: message);
      emit(FeedbackSuccessState(statusCode: statusCode));
    } on Exception catch (e) {
      emit(FeedbackFailedState(msg: e.toString()));
    }
  }
}