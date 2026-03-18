import 'package:flutter/material.dart';
import 'package:hci_final_project/homepage.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Make this container fill the entire screen
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        decoration: BoxDecoration(
          color: const Color(0xFFBFC7D1), // Login container as background
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),

              // LOGO (replace with your asset)
              Image.asset('assets/logo.png', height: 80),

              const SizedBox(height: 10),

              // TITLE
              const Text(
                "MATHMASTER",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      offset: Offset(2, 2),
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Log In",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3E5C8A),
                ),
              ),

              const Divider(thickness: 2, color: Color(0xFF3E5C8A)),

              const SizedBox(height: 15),

              // USERNAME FIELD
              _buildTextField(icon: Icons.person_outline, hint: "Username"),

              const SizedBox(height: 15),

              // PASSWORD FIELD
              _buildTextField(
                icon: Icons.lock_outline,
                hint: "Password",
                obscure: true,
              ),

              const SizedBox(height: 25),

              // LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Add Navigator.pushReplacement here
                    print("Login pressed");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E5C8A),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "LOG IN",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // LINKS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      print("Forgot password");
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Navigate to Register
                      print("Create account");
                    },
                    child: const Text(
                      "Create an account",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // GUEST BUTTON
              OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF395886)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continue as Guest",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // REUSABLE TEXTFIELD
  Widget _buildTextField({
    required IconData icon,
    required String hint,
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
