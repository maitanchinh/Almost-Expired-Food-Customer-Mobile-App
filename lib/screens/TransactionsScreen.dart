import 'package:appetit/cubit/transaction/transaction_cubit.dart';
import 'package:appetit/cubit/transaction/transaction_state.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/utils/format_utils.dart';
import 'package:appetit/utils/gap.dart';
import 'package:appetit/widgets/AppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class TransactionsScreen extends StatefulWidget {
  static const String routeName = '/transactions';
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late TransactionsCubit _transactionsCubit;
  String _transactionStatus = '';
  @override
  void initState() {
    _transactionsCubit = BlocProvider.of<TransactionsCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _transactionsCubit.getTransactions(status: _transactionStatus);
    return Scaffold(
      backgroundColor: appLayout_background,
      appBar: MyAppBar(
        title: 'Giao dịch',
        actions: [PopupMenuButton<String>(
              icon: Icon(Icons.filter_list_outlined),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Successful',
                  child: Text('Successful'),
                ),
                PopupMenuItem<String>(
                  value: 'Pending',
                  child: Text('Pending'),
                ),
                PopupMenuItem<String>(
                  value: 'Failed',
                  child: Text('Failed'),
                ),
                PopupMenuItem<String>(
                  value: 'Canceled',
                  child: Text('Canceled'),
                ),
              ],
              onSelected: (String value) {
                setState(() {
                  _transactionStatus = value;
                });
              },
            ),],
      ),
      body: BlocBuilder<TransactionsCubit, TransactionsState>(builder: (context, state) {
        if (state is TransactionsLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is TransactionsSuccessState) {
          var transactions = state.transactions.transactions;
          if (transactions!.isNotEmpty) {
          return ListView.separated(
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('HH:mm dd/MM/yyyy').format(DateTime.parse(transactions[index].createAt!)),
                        style: TextStyle(fontSize: 12),
                      ),
                      Gap.k8.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            transactions[index].status!,
                            style: TextStyle(
                                color: transactions[index].status == 'Successful'
                                    ? greenColor
                                    : transactions[index].status == 'Pending'
                                        ? Colors.amber
                                        : transactions[index].status == 'Failed'
                                            ? redColor
                                            : context.iconColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            FormatUtils.formatPrice(transactions[index].amount!.toDouble()) + ' VND',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => Gap.k8.height,
              itemCount: transactions.length);
          } else {
            return Center(child: Text('Không có giao dịch'),);
          }
        }
        return SizedBox.shrink();
      }),
    );
  }
}
