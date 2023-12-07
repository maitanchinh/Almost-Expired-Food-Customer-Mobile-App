import 'package:appetit/cubit/login/login_cubit.dart';
import 'package:appetit/cubit/login/login_state.dart';
import 'package:appetit/screens/DashboardScreen.dart';
import 'package:appetit/utils/gap.dart';
import 'package:appetit/utils/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:appetit/utils/Colors.dart';
import 'package:appetit/main.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var viewPassword = true;

  GlobalKey<FormState> mykey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginByGoogleCubit>(
      create: (context) => LoginByGoogleCubit(),
      child: BlocConsumer<LoginByGoogleCubit, LoginByGoogleState>(
        listener: (context, state) {
          if (state is LoginByGooglelSuccessState) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => DashboardScreen()));
            return;
          } else if (state is LoginByGooglelFailedState) {
            showModalBottomSheet(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text(msg_login_by_google_failed_title),
                      content: const Text(msg_login_by_google_failed_content),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ));
          }
        },
        builder: (context, state) {
          final cubit = BlocProvider.of<LoginByGoogleCubit>(context);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).viewPadding.top),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: appStore.isDarkModeOn
                              ? context.cardColor
                              : appetitAppContainerColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        width: 50,
                        height: 50,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          child: Icon(Icons.arrow_back_ios_outlined,
                              color: appetitBrownColor),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  Gap.kSection.height,
                  Gap.kSection.height,
                  Gap.kSection.height,
                  Gap.kSection.height,
                  Gap.kSection.height,
                  Text('Đăng nhập',
                      style:
                          TextStyle(fontSize: 45, fontWeight: FontWeight.w500)),
                  Gap.kSection.height,
                  Container(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        cubit.loginByGoole();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: appStore.isDarkModeOn
                              ? context.cardColor
                              : appetitAppContainerColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Image.asset('image/appetit/google.png',
                          width: 70, height: 70),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
