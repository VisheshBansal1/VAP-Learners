import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learnify/notes/change_notifier/notes_provider.dart';
import 'package:learnify/notes/change_notifier/registration_controller.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ================= VAP LEARNERS =================
import 'firebase_options.dart';
import 'theme/theme_controller.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard/dashboard.dart';
import 'splash_screen/onboarding_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();

  final themeController = ThemeController();
  await themeController.init();

  runApp(
    MultiProvider(
      providers: [
        // ================= THEME =================
        ChangeNotifierProvider.value(value: themeController),

        // ================= NOTES (REAL-TIME) =================
        ChangeNotifierProvider(create: (_) => NotesProvider()),

        // ================= AUTH =================
        ChangeNotifierProvider(create: (_) => RegistrationController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeController>();

    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VAP Learners',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: theme.themeMode,
        home: const AuthWrapper(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
        ],
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? _user;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _verifyUser();
  }

  Future<void> _verifyUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.reload();
        setState(() {
          _user = FirebaseAuth.instance.currentUser;
          _checking = false;
        });
      } catch (_) {
        await FirebaseAuth.instance.signOut();
        setState(() {
          _user = null;
          _checking = false;
        });
      }
    } else {
      setState(() {
        _user = null;
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        backgroundColor: Color(0xFF151022),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (_user != null) {
      // 🔹 VAP Home
      return const HomeScreen();
    } else {
      // 🔹 VAP Onboarding
      return OnboardingWrapper();
    }
  }
}
