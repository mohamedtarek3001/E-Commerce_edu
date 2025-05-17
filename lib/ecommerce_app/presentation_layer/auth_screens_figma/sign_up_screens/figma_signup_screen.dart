import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../business_logic/blocs_cubits/auth_cubit.dart';
import '../../widgets/custom_input_field.dart';
import '../login_screens/login_screen.dart';

class FigmaSignupScreen extends StatelessWidget {
  const FigmaSignupScreen({super.key});

  static final GlobalKey<FormState> _key = GlobalKey<FormState>();

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
          child: Form(
            key: _key,
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
                    'Create account',
                    style: TextStyle(color: Color(0xff22C7B6), fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomInputField(
                        title: 'Email',
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
                    height: 30,
                  ),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return CustomInputField(
                        title: 'Confirm Password',
                        hint: '*********',
                        controller: context.read<AuthCubit>().confirmPasswordController,
                        isVisible: context.read<AuthCubit>().isVisible,
                        isPassword: true,
                        icon: null,
                        validator: (value) {
                          if (value != context.read<AuthCubit>().passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
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
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      print(state);
                      if (state is AuthSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.greenAccent,
                            content: Text('Account Created successfully'),
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
                                if (_key.currentState!.validate()) {
                                  await context.read<AuthCubit>().register();
                                }

                                print('login pressed');
                              },
                        child: state is AuthLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                            : const Text(
                                'Create Account',
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
                        'Already have an account? ',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreenFigma(),
                              ),
                            );
                          },
                          child: const Text('Login')),
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
      ),
    );
  }
}
