import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_final_project/login_wrapper.dart';
import 'package:hci_final_project/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class SubjectContent {
  String title;
  String description;
  String imagePath; // Expects a String for the file path

  SubjectContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _showHomeContent = true;
  int _selectedAvatar = 0;

  final List<String> avatars = [
    "assets/avatars/brook.JPG",
    "assets/avatars/chopper.JPG",
    "assets/avatars/franky.JPG",
    "assets/avatars/jinbe.JPG",
    "assets/avatars/luffy.JPG",
    "assets/avatars/nami.JPG",
    "assets/avatars/robin.JPG",
    "assets/avatars/sanji.JPG",
    "assets/avatars/usopp.JPG",
    "assets/avatars/zoro.JPG",
  ];

  // Screens for each tab (you can replace later)
  List<Widget> get _pages => [
    Builder(builder: (context) => _subjectsContent(context)),
    const Center(child: Text("Progress Screen")),
    Builder(builder: (context) => _profileContent(context)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showHomeContent = false;
    });
  }

  void _navigateFromDrawer({int? bottomNavIndex, bool showHome = false}) {
    setState(() {
      _showHomeContent = showHome;
      if (bottomNavIndex != null) {
        _selectedIndex = bottomNavIndex;
      }
    });

    Navigator.of(context).pop();
  }

  void _showAvatarPicker() {
    showDialog(
      context: context,
      builder: (context) {
        int tempSelected = _selectedAvatar;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Choose Avatar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),

                    const SizedBox(height: 10),

                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: avatars.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemBuilder: (context, index) {
                        final isSelected = tempSelected == index;

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempSelected = index;
                            });
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: isSelected
                                ? Colors.blue
                                : Colors.grey[300],
                            child: CircleAvatar(
                              radius: 26,
                              backgroundImage: AssetImage(avatars[index]),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedAvatar = tempSelected;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sizes = theme.extension<AppSizes>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,

      appBar: AppBar(title: const Text("MathMaster")),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => _navigateFromDrawer(showHome: true),
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Subjects'),
              onTap: () => _navigateFromDrawer(bottomNavIndex: 0),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Progress'),
              onTap: () => _navigateFromDrawer(bottomNavIndex: 1),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => _navigateFromDrawer(bottomNavIndex: 2),
            ),
          ],
        ),
      ),

      // ✅ Change body based on selected tab
      body: _showHomeContent ? _homeContent(context) : _pages[_selectedIndex],

      // ✅ Bottom Navigation Bar
      bottomNavigationBar: SizedBox(
        height: sizes?.bottomNavHeight ?? 72,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Subjects'),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Progress',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  // Home Page
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

  // Subjects Page
  Widget _subjectsContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _subjectButton(context, "Algebra", const Color(0xFF395886), () {
            print("Algebra pressed");
          }),
          const SizedBox(height: 16),
          _subjectButton(context, "Geometry", const Color(0xFF395886), () {
            print("Geometry pressed");
          }),
        ],
      ),
    );
  }

  // Profile Page
  Widget _profileContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(avatars[_selectedAvatar]),
                ),
                const SizedBox(width: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Yamato",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),

                    const SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: _showAvatarPicker,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[200],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Change Avatar"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(color: Colors.black),

          // 🔹 Stats Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• Quizzes Completed: 12"),
                SizedBox(height: 8),
                Text("• Badges Earned: 5"),
              ],
            ),
          ),

          const Divider(color: Colors.black),

          // 🔹 Settings Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: Color(0xFF7C9BCB),
              ),
              child: const Text("Settings"),
            ),
          ),

          const Spacer(),

          // 🔹 Logout Button
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(220, 50),
                backgroundColor: Color(0xFF7C9BCB),
              ),
              child: const Text("LOG OUT"),
            ),
          ),
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

  // ✅ Reusable button
  Widget _subjectButton(
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
