import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled2/ecommerce_app/business_logic/blocs_cubits/auth_cubit.dart';

import 'ecommerce_app/business_logic/blocs_cubits/navigation_cubit.dart';
import 'ecommerce_app/business_logic/blocs_cubits/product_cubit.dart';
import 'ecommerce_app/presentation_layer/auth_screens/login_screens/login_screen.dart';
import 'ecommerce_app/presentation_layer/auth_screens_figma/login_screens/login_screen.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: "https://ipyemewznxaiwpenndob.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlweWVtZXd6bnhhaXdwZW5uZG9iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY4OTk4MTEsImV4cCI6MjA2MjQ3NTgxMX0.X8RE_6Zl1q_7YTUXVGyn5_UKJhFMiYmxvDbM5ksc3c0",
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => ProductCubit(),
        ),
        BlocProvider(
          create: (context) => NavigationCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "E-Commerce App",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff22C7B6)),
      ),
      home: LoginScreenFigma(),
      // home: TestCubitStateManagement(),
    );
  }
}

// StatefulWidget------------------ statelessWidget

//------------------Layout Widgets--------------------- (Column-Row-Stack-flexable-align)

//------------------Basic Widgets---------------------(Container-Buttons-images-text)

//------------------Scrollable widgets-----------------(SingleChildScrollView-ListViewBuilder-GridViewBuilder)

//------------------Animation Widgets------------------(AnimatedContainer-AnimatedSwitcher-AnimatedList)
