import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/ecommerce_app/model_layer/login_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  bool isVisible = true;

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController(text: 'mohamedtarek1428@gmail.com');
  TextEditingController passwordController = TextEditingController(text: '654321');
  TextEditingController confirmPasswordController = TextEditingController();

  changeVisibility() {
    isVisible = !isVisible;
    emit(VisibilityChanged());
  }

  LoginModel? user;

  Future login({String? username, String? password}) async {
    emit(AuthLoading());
    var body = {
      'username': username ?? emailController.text,
      'password': password ?? passwordController.text,
    };
    var headers = {'Content-Type': 'application/json'};
    String url = 'https://fakestoreapi.com/auth/login';
    try {
      var response = await http.post(Uri.parse(url), headers: headers, body: json.encode(body));
      if (response.statusCode == 200) {
        user = LoginModel.fromJson(json.decode(response.body));
        emit(AuthSuccess());
        return null;
      } else {
        emit(AuthFail(error: response.body));
        return response.body;
      }
    } catch (e) {
      emit(AuthFail(error: e.toString()));
      return e.toString();
    }
  }

  Future register({String? email, String? password}) async {
    emit(AuthLoading());
    try{
      var user = await auth.createUserWithEmailAndPassword(
        email: email ?? emailController.text,
        password: password ?? passwordController.text,
      );
      if(user.user != null){
        emit(AuthSuccess());
      }else{
        emit(AuthFail(error: 'Something went wrong'));
      }
    } catch(e){
      emit(AuthFail(error: e.toString()));
    } finally{
      emit(AuthInitial());
      // emailController.clear();
      // passwordController.clear();
      // confirmPasswordController.clear();
    }

  }

  Future fireAuthLogin({String? email, String? password}) async {
    emit(AuthLoading());
    try{
      var user = await auth.signInWithEmailAndPassword(
        email: email ?? emailController.text,
        password: password ?? passwordController.text,
      );
      if(user.user != null){
        emit(AuthSuccess());
      }else{
        emit(AuthFail(error: 'Wrong credentials!!'));
      }
    } catch(e){
      emit(AuthFail(error: e.toString()));
    }
  }

  Future sendForgetPassword({String? email}) async {
    emit(AuthLoading());
    try{
      await auth.sendPasswordResetEmail(
        email: email ?? emailController.text,
      );

        emit(MailSentSuccess());

    } catch(e){
      emit(MailSendFail(error: e.toString()));
    }finally{
      emit(AuthInitial());
    }
  }
}
