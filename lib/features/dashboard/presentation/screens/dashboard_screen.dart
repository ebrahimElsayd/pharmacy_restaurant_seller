import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pharmacy_restaurant_seller/features/orders/presentation/screens/orders_list_screen.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../auth/presentation/riverpods/auth_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppPallete.primaryColor,
        foregroundColor: AppPallete.whiteColor,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.account_circle),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to profile
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to settings
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () async {
                    Navigator.pop(context);
                    await ref.read(authNotifierProvider.notifier).signOut();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppPallete.primaryColor,
                    AppPallete.primaryColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Dashboard!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hello, ${user?.fullName ?? 'User'}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppPallete.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppPallete.whiteColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Quick actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppPallete.blackForText,
              ),
            ),
            const SizedBox(height: 16),

            // Action cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildActionCard(
                    'Orders',
                    Icons.shopping_bag,
                    AppPallete.primaryColor,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => OrdersListScreen(
                              ), // <-- تمرير معرف الطلب
                            ),
                          );
                    },
                  ),
                  _buildActionCard(
                    'Products',
                    Icons.inventory,
                    Colors.green,
                        () {
                      // Navigate to products
                    },
                  ),
                  _buildActionCard(
                    'Analytics',
                    Icons.analytics,
                    Colors.orange,
                        () {
                      // Navigate to analytics
                    },
                  ),
                  _buildActionCard(
                    'Settings',
                    Icons.settings,
                    Colors.purple,
                        () {
                      // Navigate to settings
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppPallete.blackForText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
