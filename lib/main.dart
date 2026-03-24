import 'package:flutter/material.dart';
import 'package:hci_final_project/login_wrapper.dart';
import 'package:hci_final_project/theme/app_theme.dart';
import 'package:hci_final_project/onboardingscreen.dart';
import 'package:hci_final_project/progress_page.dart';
import 'homepage.dart';
import 'local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool loggedIn = await LocalStorage.isLoggedIn();

  runApp(MainApp(startLoggedIn: loggedIn));
}

class MainApp extends StatelessWidget {
  final bool startLoggedIn;

  const MainApp({super.key, required this.startLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: FutureBuilder<bool>(
        future: LocalStorage.isLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Show loading spinner while checking storage
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          bool loggedIn = snapshot.data ?? false;
          return ProgressPage();
          //return loggedIn ? const HomeScreen() : const LoginScreen();
        },
      ),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        // '/login': (context) => const LoginWrapper(),
        // '/dragdrop': (context) => const DragAndDropTest(),
      },
    );
  }
}
