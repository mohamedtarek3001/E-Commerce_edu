import 'package:flutter/material.dart';

import '../../widgets/custom_input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool isVisible = true;
  //MediaQuery

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print('width: $width, height: $height');
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.purple[500]!,
                      Colors.blue[900]!,
                      const Color(0xFF0C0950),
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Sign up now and begin your journey',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ), // first section
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Form(
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: height *0.03,
                        ),
                        const Text(
                          'Create Your Account.',
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, height: 2),
                        ),
                        Text(
                          'Let\'s sign up to get started',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: Colors.grey[700]),
                        ),
                        SizedBox(
                          height: height *0.04,
                        ),
                        CustomInputField(
                          controller: emailController,
                          icon: Icons.email_outlined,
                          isPassword: false,
                          isVisible: false,
                          hint: 'Enter your email address..',
                          title: 'Email Address',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Email Address';
                            } else if (value.contains(' ')) {
                              return 'Email Address cannot contain spaces';
                            } else if (!value.contains('@') || !value.contains('.com')) {
                              return 'Please enter a valid Email Address';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: height *0.02,
                        ),
                        CustomInputField(
                          controller: fullNameController,
                          icon: Icons.person,
                          isPassword: false,
                          isVisible: false,
                          hint: 'Enter your full name..',
                          title: 'Full name',
                          validator: (value) {
                           return null;
                          },
                        ),
                        SizedBox(
                          height: height *0.02,
                        ),
                        CustomInputField(
                          controller: usernameController,
                          icon: Icons.supervised_user_circle_outlined,
                          isPassword: false,
                          isVisible: false,
                          hint: 'Enter your user name..',
                          title: 'Username',
                          validator: (value) {
                              return null;
                          },
                        ),
                        SizedBox(
                          height: height *0.02,
                        ),
                        CustomInputField(
                          controller: passwordController,
                          icon: Icons.lock,
                          isPassword: true,
                          isVisible: isVisible,
                          suffixIcon: isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          hint: 'Enter your password..',
                          title: 'Password',
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: height *0.02,
                        ),
                        CustomInputField(
                          controller: confirmPasswordController,
                          icon: Icons.lock,
                          isPassword: true,
                          isVisible: isVisible,
                          suffixIcon: isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          hint: 'Re-enter your password..',
                          title: 'Password Confirmation',
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          validator: (value) {
                            if (value != null && value != passwordController.text) {
                              return 'Passwords do not match';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: height *0.04,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1e35e1),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              minimumSize: const Size(double.infinity, 50)),
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                            }
                          },

                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.login,
                                size: 27,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height *0.04,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {

                              },
                              child: const Text('Sign In', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.purple,),),
                            )
                          ],
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ), // second section
            // 1:3 ratio
          ],
        ),
      ),
    );
  }
}