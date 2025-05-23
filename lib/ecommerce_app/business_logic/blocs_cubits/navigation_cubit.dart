import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../presentation_layer/main_app/Home_pages/home_screen.dart';
import '../../presentation_layer/main_app/product_addition_screens/product_addition_screen.dart';
import '../../presentation_layer/main_app/profile_screens/profile_screen.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationInitial());
  int currentIndex = 0;

  setCurrentIndex(int index){
    currentIndex = index;
    emit(NavigationInitial());
  }

  List<Widget> screens = [
    HomeScreen(),
    ProductAdditionScreen(),
    ProfileScreen()
  ];

}
