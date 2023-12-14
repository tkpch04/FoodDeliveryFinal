import 'package:flutter/material.dart';
import 'package:food_delivery_apps/model/cart_model.dart';
import 'package:food_delivery_apps/pages/splash_page.dart';
import 'package:food_delivery_apps/pages/welcome_page.dart';
import 'package:food_delivery_apps/pages/home_page.dart';
import 'package:food_delivery_apps/pages/cart_page.dart';
import 'package:food_delivery_apps/pages/account_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ImageProviderModel()),
        ChangeNotifierProvider(create: (context) => CartModel()),
        // Other providers if any
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
      home: SplashPage(),
      routes: {
        '/login': (context) => const WelcomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CartScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming you are using Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    // Mendapatkan Data User dari Uid
    String uid = user?.uid ?? '';
    return Center(
      child: HomePage(
        uid: uid,
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming you are using Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    // Mendapatkan Data User dari Uid
    String uid = user?.uid ?? '';
    return Center(
      child: CartPage(
        uid: uid,
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Assuming you are using Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;

    // Mendapatkan Data User dari Uid
    String uid = user?.uid ?? '';
    return Center(
      child: AccountPage(
        uid: uid,
      ),
    );
  }
}
