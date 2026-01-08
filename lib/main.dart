import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learnify/notes/normal_notes/models/note_section.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ================= FIREBASE =================
import 'firebase_options.dart';

// ================= THEME =================
import 'theme/theme_controller.dart';
import 'theme/app_theme.dart';

// ================= SCREENS =================
import 'screens/dashboard/dashboard.dart';
import 'splash_screen/onboarding_wrapper.dart';

// ================= NOTES =================
import 'notes/normal_notes/models/note.dart';
import 'notes/ai_notes/notes_generator/model/ai_note.dart';
import 'notes/ai_notes/notes_generator/model/ai_note_section.dart';
import 'notes/normal_notes/change_notifier/notes_provider.dart';

// ================= AUTH =================
import 'notes/normal_notes/change_notifier/registration_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---------------- ENV ----------------
  await dotenv.load(fileName: ".env");

  // ---------------- FIREBASE ----------------
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ---------------- HIVE ----------------
  await Hive.initFlutter();

  // ✅ REGISTER ADAPTERS (TYPE IDs MUST NEVER CHANGE)
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(NoteAdapter()); // Normal notes
  }

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(AiNoteAdapter()); // AI notes
  }

  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(AiNoteSectionAdapter()); // AI sections
  }

  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(NoteSectionAdapter()); // Normal sections
  }

  // ✅ OPEN ALL REQUIRED BOXES (ONCE)
  await Hive.openBox<Note>('notesBox');
  await Hive.openBox<AiNote>('aiNotesBox');
  await Hive.openBox<AiNoteSection>('sectionsBox'); // AI sections
  await Hive.openBox<NoteSection>('noteSectionsBox'); // Normal sections

  // ---------------- THEME ----------------
  final themeController = ThemeController();
  await themeController.init();

  // ---------------- APP ----------------
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeController),

        // ⚠️ Providers must NEVER open boxes
        ChangeNotifierProvider(create: (_) => NotesProvider()),
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

// ================= AUTH WRAPPER =================

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
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.reload();
        _user = FirebaseAuth.instance.currentUser;
      } else {
        _user = null;
      }
    } catch (_) {
      await FirebaseAuth.instance.signOut();
      _user = null;
    } finally {
      if (mounted) {
        setState(() => _checking = false);
      }
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

    return _user != null ? const HomeScreen() : OnboardingWrapper();
  }
}
