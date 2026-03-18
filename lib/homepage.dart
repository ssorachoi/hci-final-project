import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Screens for each tab (you can replace later)
  final List<Widget> _pages = [
    const Center(child: Text("Subjects Screen")),
    const Center(child: Text("Progress Screen")),
    const Center(child: Text("Profile Screen")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFC7D1),

      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          "MathMaster",
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25),
        ),
        backgroundColor: const Color(0xFF395886),
        foregroundColor: Colors.white,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Home')),
            ListTile(leading: Icon(Icons.book), title: Text('Subjects')),
            ListTile(leading: Icon(Icons.bar_chart), title: Text('Progress')),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
          ],
        ),
      ),

      // ✅ Change body based on selected tab
      body: _selectedIndex == 0
          ? _homeContent(context)
          : _pages[_selectedIndex],

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF395886),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Subjects'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // ✅ Your original home buttons
  Widget _homeContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(context, "Subjects", const Color(0xFF395886), () {
            print("Subjects pressed");
          }),
          const SizedBox(height: 32),
          _buildButton(context, "Achievements", const Color(0xFF395886), () {
            print("Achievements pressed");
          }),
          const SizedBox(height: 32),
          _buildButton(context, "Progress", const Color(0xFF395886), () {
            print("Progress pressed");
          }),
        ],
      ),
    );
  }

  // ✅ Reusable button
  Widget _buildButton(
    BuildContext context,
    String text,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 220,
      height: 60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFF395886),
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(text, style: GoogleFonts.poppins(fontSize: 20)),
      ),
    );
  }
}
