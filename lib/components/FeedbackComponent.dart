import 'package:appetit/cubit/feedback/feadback_cubit.dart';
import 'package:appetit/cubit/feedback/feedback_state.dart';
import 'package:appetit/screens/OrderDetailsScreen.dart';
import 'package:appetit/utils/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

class FeedbackComponent extends StatefulWidget {
  final String productId;
  final String orderId;
  const FeedbackComponent({Key? key, required this.productId, required this.orderId}) : super(key: key);

  @override
  State<FeedbackComponent> createState() => _FeedbackComponentState();
}

class _FeedbackComponentState extends State<FeedbackComponent> {
  int rate = 5;
  late FeedbackCubit _feedbackCubit;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    _feedbackCubit = BlocProvider.of<FeedbackCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackCubit, FeedbackState>(
      listener: (context, state) {
        if (!(state is FeedbackLoadingState)) {
          Navigator.pop(context);
        }
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => ProcessingPopup(
                  state: state,
                  orderId: widget.orderId,
                ));
      },
      child: Dialog(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Chất lượng sản phẩm'),
            Gap.k8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  children: List.generate(
                    rate,
                    (index) => Icon(
                      Icons.star_rate,
                      color: Colors.amber,
                    ).onTap(() {
                      setState(() {
                        rate = index + 1;
                      });
                    }),
                  ),
                ),
                Wrap(
                  children: List.generate(
                    5 - rate,
                    (index) => Icon(
                      Icons.star_rate_outlined,
                      color: Colors.amber,
                    ).onTap(() {
                      setState(() {
                        rate = rate + index + 1;
                      });
                    }),
                  ),
                ),
              ],
            ),
            Gap.k8.height,
            Text('Nhận xét'),
            Gap.k8.height,
            TextField(
              controller: _messageController,
              style: TextStyle(fontSize: 12),
              maxLines: 5,
              decoration: InputDecoration(hintText: 'Hãy chia sẻ nhận xét của bạn về sản phẩm này nhé!', hintStyle: TextStyle(fontSize: 12), border: OutlineInputBorder()),
            ),
            Gap.k16.height,
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.orange.shade700), borderRadius: BorderRadius.circular(4)),
                    child: Center(
                        child: Text(
                      'Đóng',
                      style: TextStyle(color: Colors.orange.shade700),
                    )),
                  ).onTap(() {
                    Navigator.pop(context);
                  }),
                ),
                Gap.k8.width,
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.orange.shade700), borderRadius: BorderRadius.circular(4), color: Colors.orange.shade700),
                    child: Center(
                        child: Text(
                      'Gửi',
                      style: TextStyle(color: white),
                    )),
                  ).onTap(() async {
                    await _feedbackCubit.feedback(productId: widget.productId, star: rate, message: _messageController.text);
                    Navigator.pop(context);
                  }),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}

class ProcessingPopup extends StatelessWidget {
  final String orderId;
  final FeedbackState state;
  const ProcessingPopup({
    Key? key,
    required this.state,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: state is FeedbackLoadingState
            ? Container(
                width: 150,
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Gap.k16.height,
                    Text('Đang xử lý, vui lòng chờ.')
                  ],
                ))
            : state is FeedbackSuccessState
                ? Container(
                    width: 150,
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Gửi phản hồi thành công'),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.pushNamed(context, OrderDetailsScreen.routeName, arguments: orderId);
                            },
                            child: Text(
                              'Đóng',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                      ],
                    ))
                : state is FeedbackFailedState
                    ? Container(
                        width: 150,
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              (state as FeedbackFailedState).msg.replaceAll('Exception: ', ''),
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Đóng'))
                          ],
                        ),
                      )
                    : Container(
                        height: 150,
                        width: 150,
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Đã xãy ra sự cố, hãy thử lại'),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Đóng',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))
                          ],
                        ),
                      ));
  }
}
