import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zypto_plus_app/screens/favoriteScreen.dart';
import 'package:zypto_plus_app/screens/homeScreen.dart';
import 'package:zypto_plus_app/screens/loginScreen.dart';
import 'package:zypto_plus_app/screens/signupScreen.dart';
import 'package:zypto_plus_app/screens/splashScreen.dart';
import 'package:zypto_plus_app/screens/welcomeScreen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return MaterialApp.router(
      title: 'ZyptoPulse',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => SignupScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/favorites', builder: (context, state) => FavouritesScreen()),
    GoRoute(path: '/welcome', builder: (context, state) => Welcomescreen()),
  ],
);