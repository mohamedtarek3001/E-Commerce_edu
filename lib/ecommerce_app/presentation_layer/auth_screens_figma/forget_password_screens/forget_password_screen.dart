import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../business_logic/blocs_cubits/auth_cubit.dart';
import '../../widgets/custom_input_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: height * 0.033,
                ),
                SvgPicture.asset(
                  'assets/appIcons/app_icon.svg',
                  height: height * 0.135,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: (height - ((height * 0.0899) + (height * 0.135))) * 0.111,
                ),
                const Text(
                  'Reset Password',
                  style: TextStyle(color: Color(0xff22C7B6), fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'please enter your mail address to resets your password',
                  style: TextStyle(color: Color(0x991A1A1A), fontSize: 16, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return CustomInputField(
                      title: 'User Email',
                      hint: 'example@gmail.com',
                      controller: context.read<AuthCubit>().emailController,
                      isVisible: false,
                      isPassword: false,
                      icon: null,
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is MailSentSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.greenAccent,
                          content: Text('Email Sent successfully'),
                        ),
                      );
                    } else if (state is MailSendFail) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(state.error),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        backgroundColor: const Color(0xff22C7B6),
                        foregroundColor: Colors.white,
                        minimumSize: Size(width, 56),
                        maximumSize: Size(width, 56),
                      ),
                      onPressed: state is AuthLoading
                          ? null
                          : () async {
                        await context.read<AuthCubit>().sendForgetPassword();

                        print('send pressed');
                      },
                      child: state is AuthLoading
                          ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                          : const Text(
                        'Send',
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
