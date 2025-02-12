import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rideshare/screens/home_screen.dart';
import 'package:rideshare/screens/auth_screen.dart';
import 'package:rideshare/screens/offer_ride_screen.dart';
import 'package:rideshare/screens/search_rides_screen.dart';
import 'package:rideshare/screens/my_rides_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/offer-ride',
      builder: (context, state) => const OfferRideScreen(),
    ),
    GoRoute(
      path: '/search-rides',
      builder: (context, state) => const SearchRidesScreen(),
    ),
    GoRoute(
      path: '/my-rides',
      builder: (context, state) => const MyRidesScreen(),
    ),
  ],
);