import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../business_logic/blocs_cubits/auth_cubit.dart';
import '../../main_app/product_addition_screens/product_addition_screen.dart';
import '../../widgets/custom_input_field.dart';
import '../forget_password_screens/forget_password_screen.dart';
import '../sign_up_screens/figma_signup_screen.dart';

class LoginScreenFigma extends StatelessWidget {
  const LoginScreenFigma({super.key});

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
                  'Login',
                  style: TextStyle(color: Color(0xff22C7B6), fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return CustomInputField(
                      title: 'User name',
                      hint: 'John_doe.',
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
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return CustomInputField(
                      title: 'Password',
                      hint: '*********',
                      controller: context.read<AuthCubit>().passwordController,
                      isVisible: context.read<AuthCubit>().isVisible,
                      isPassword: true,
                      icon: null,
                      suffixIcon: context.read<AuthCubit>().isVisible ? Icons.visibility_off : Icons.visibility,
                      onPressed: () {
                        context.read<AuthCubit>().changeVisibility();
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: false,
                        onChanged: (value) {},
                        title: const Text('Remember Me'),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgetPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text('Forgot your Password?'))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.greenAccent,
                          content: Text('Logged in successfully'),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductAdditionScreen(),
                        ),
                      );
                    } else if (state is AuthFail) {
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
                              await context.read<AuthCubit>().fireAuthLogin();

                              print('login pressed');
                            },
                      child: state is AuthLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                          : const Text(
                              'Login',
                              style: TextStyle(fontSize: 15),
                            ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FigmaSignupScreen(),
                            ),
                          );
                        },
                        child: const Text('Create Account')),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        color: Color(0xff22C7B6),
                        height: 1,
                        thickness: 0.7,
                        indent: 40,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      'OR',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Expanded(
                      child: Divider(
                        color: Color(0xff22C7B6),
                        height: 1,
                        thickness: 0.7,
                        indent: 10,
                        endIndent: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/appIcons/google_icon.png',
                  height: 35,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
