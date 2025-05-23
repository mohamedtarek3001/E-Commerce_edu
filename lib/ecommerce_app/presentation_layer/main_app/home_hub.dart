import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/blocs_cubits/navigation_cubit.dart';

class HomeHub extends StatelessWidget {
  const HomeHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          int currentIndex = context.read<NavigationCubit>().currentIndex;
          return Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: context.read<NavigationCubit>().screens[currentIndex],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return CurvedNavigationBar(
            color: Color(0xff22C7B6),
            backgroundColor: Colors.white,
            buttonBackgroundColor: Color(0xff2E3A58),
            onTap: (value) {
              context.read<NavigationCubit>().setCurrentIndex(value);
            },
            index: context.read<NavigationCubit>().currentIndex,
            items: [
              CurvedNavigationBarItem(
                child: Icon(Icons.home,color: Colors.white,),
                label: 'Home',
                labelStyle: TextStyle(color: Colors.white)
              ),
              CurvedNavigationBarItem(child: Icon(Icons.add,color: Colors.white,size: 35,), label: 'Product Addition',
                  labelStyle: TextStyle(color: Colors.white)),
              CurvedNavigationBarItem(child: Icon(Icons.person,color: Colors.white,), label: 'Profile',
                  labelStyle: TextStyle(color: Colors.white)),
            ],
          );
        },
      ),
    );
  }
}
