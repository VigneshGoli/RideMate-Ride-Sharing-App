import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rideshare/providers/auth_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('RideShare Hub'),
        actions: [
          if (authProvider.isAuthenticated)
            IconButton(
              icon: const Icon(LucideIcons.logOut),
              onPressed: () => authProvider.signOut(),
            )
          else
            TextButton.icon(
              icon: const Icon(LucideIcons.user),
              label: const Text('Sign In'),
              onPressed: () => context.push('/auth'),
            ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Image.network(
            'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.6),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share Your Journey',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Connect with travelers heading your way. Save money, reduce carbon footprint, and make new friends along the way.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(LucideIcons.car),
                  label: const Text('Offer a Ride'),
                  onPressed: () {
                    if (authProvider.isAuthenticated) {
                      context.push('/offer-ride');
                    } else {
                      context.push('/auth');
                    }
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(LucideIcons.search),
                  label: const Text('Find a Ride'),
                  onPressed: () {
                    if (authProvider.isAuthenticated) {
                      context.push('/search-rides');
                    } else {
                      context.push('/auth');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}