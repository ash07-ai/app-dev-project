import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/constants/colors.dart';
import 'core/constants/app_constants.dart';
import 'core/utils/routes.dart';
import 'data/providers/cart_provider.dart';
import 'data/providers/order_provider.dart';
import 'data/providers/product_provider.dart';
import 'data/providers/user_provider.dart';
import 'data/providers/favorites_provider.dart';
import 'core/services/firebase_auth_service.dart';
import 'features/auth/pages/login_page.dart';
import 'features/auth/pages/signup_page.dart';
import 'features/auth/pages/forgot_password_page.dart';
import 'features/auth/pages/splash_page.dart';
import 'features/home/pages/home_page.dart';
import 'features/home/pages/favorites_page.dart';
import 'features/product/pages/product_detail_page.dart';
import 'features/cart/pages/cart_page.dart';
import 'features/cart/pages/checkout_page.dart';
import 'features/profile/pages/profile_page.dart';
import 'features/profile/pages/orders_page.dart';
import 'features/profile/pages/settings_page.dart';
import 'features/profile/pages/wishlist_page.dart';
import 'features/profile/pages/shipping_addresses_page.dart';
import 'features/profile/pages/payment_methods_page.dart';
import 'features/admin/pages/admin_dashboard_page.dart';
import 'features/admin/pages/order_management_page.dart';
import 'features/admin/pages/product_management_page.dart';
import 'features/admin/pages/user_management_page.dart';
import 'features/admin/pages/analytics_page.dart';
import 'features/product/pages/product_review_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthService()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          useMaterial3: false,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Roboto',

          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            background: AppColors.background,
            surface: AppColors.surface,
          ),

          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.surface,
            elevation: 0,
            foregroundColor: AppColors.textPrimary,
            centerTitle: false,
            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 11,
            ),
            showUnselectedLabels: true,
          ),
        ),

        initialRoute: AppRoutes.splash,
        
        routes: {
          AppRoutes.splash: (context) => const SplashPage(),
          AppRoutes.login: (context) => const LoginPage(),
          AppRoutes.signup: (context) => const SignupPage(),
          AppRoutes.forgotPassword: (context) => const ForgotPasswordPage(),
          AppRoutes.home: (context) => const HomePage(),
          AppRoutes.favorites: (context) => const FavoritesPage(),
          AppRoutes.cart: (context) => const CartPage(),
          AppRoutes.checkout: (context) => const CheckoutPage(),
          AppRoutes.profile: (context) => const ProfilePage(),
          AppRoutes.admin: (context) => const AdminDashboardPage(),
          AppRoutes.orderManagement: (context) => const OrderManagementPage(),
          AppRoutes.productManagement: (context) => const ProductManagementPage(),
          AppRoutes.userManagement: (context) => const UserManagementPage(),
          AppRoutes.analytics: (context) => const AnalyticsPage(),
          AppRoutes.orders: (context) => const OrdersPage(),
          AppRoutes.settings: (context) => const SettingsPage(),
          AppRoutes.wishlist: (context) => const WishlistPage(),
          AppRoutes.shippingAddresses: (context) => const ShippingAddressesPage(),
          AppRoutes.paymentMethods: (context) => const PaymentMethodsPage(),
        },

        onGenerateRoute: (settings) {
          if (settings.name?.startsWith('/product/') ?? false) {
            final productId = settings.name!.split('/').last;
            return MaterialPageRoute(
              builder: (context) => ProductDetailPage(productId: productId),
            );
          }

          if (settings.name?.startsWith('/product-reviews/') ?? false) {
            final productId = settings.name!.split('/').last;
            return MaterialPageRoute(
              builder: (context) => ProductReviewPage(productId: productId),
            );
          }

          return null;
        },

        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Route not found: ${settings.name}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.splash),
                      child: const Text('Go to Home'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}