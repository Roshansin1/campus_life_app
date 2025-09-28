// lib/main.dart
import 'package:campus_life_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/rsvp/rsvp_screen.dart';
import 'screens/events/events_list_screen.dart';
import 'screens/events/event_detail_screen.dart';
import 'screens/announcements_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/events/create_event_screen.dart';

void main() {
  runApp(const CampusLifeApp());
}

class CampusLifeApp extends StatelessWidget {
  const CampusLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: MaterialApp(
        title: 'Campus Life',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          // Optional: adjust typography here if desired
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const EntryPoint(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => const RegistrationScreen(), 
          '/home': (context) => HomeScreen(),
          '/events': (context) => EventsListScreen(),
          '/rsvp': (context) => const RsvpScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/create-event': (context) => const CreateEventScreen(),

        },
      ),
    );
  }
}

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});
  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.tryAutoLogin();
    if (auth.isAuthenticated) {
      if (mounted) Navigator.of(context).pushReplacementNamed('/home');
    } else {
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
