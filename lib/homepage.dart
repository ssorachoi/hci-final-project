import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hci_final_project/login_wrapper.dart';
import 'package:hci_final_project/theme/app_theme.dart';
import '../data/lessons/linear_algebra.dart';
import '../data/lessons/integral_calculus.dart';
import '../data/lessons/physics.dart';
import '../data/lessons/chemistry.dart';
import 'screens/lessons_list_screen.dart';
import 'local_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _showHomeContent = true;
  bool _showSettingsContent = false;

  bool get _isInMainTabs => !_showHomeContent && !_showSettingsContent;

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
    Builder(builder: (context) => _settingsContent(context)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showHomeContent = false;
      _showSettingsContent = false;
    });
  }

  void _navigateFromDrawer({
    int? bottomNavIndex,
    bool showHome = false,
    bool showSettings = false,
  }) {
    setState(() {
      _showHomeContent = showHome;
      _showSettingsContent = showSettings;
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
              decoration: BoxDecoration(color: Color(0xFF395886)),
              child: Text(
                'MathMaster',
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
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => _navigateFromDrawer(bottomNavIndex: 2),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => _navigateFromDrawer(showSettings: true),
            ),
          ],
        ),
      ),

      body: _showHomeContent
          ? _homeContent(context)
          : _showSettingsContent
          ? _settingsContent(context)
          : _pages[_selectedIndex],

      bottomNavigationBar: SizedBox(
        height: sizes?.bottomNavHeight ?? 72,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,

          selectedItemColor: _isInMainTabs ? Colors.black : Colors.white,
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
            setState(() {
              _showHomeContent = false; // hide home
              _selectedIndex = 0; // show subjects tab
            });
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
          _buildButton(context, "Linear Algebra", const Color(0xFF395886), () {
            // Navigate to the LessonsScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonsScreen(
                  lessons: linearAlgebraLessons, // your list of Lesson objects
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
          _buildButton(
            context,
            "Integral Calculus",
            const Color(0xFF395886),
            () {
              // Navigate to the LessonsScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonsScreen(
                    lessons:
                        integralCalculusLessons, // your list of Lesson objects
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          _buildButton(context, "Physics", const Color(0xFF395886), () {
            // Navigate to the LessonsScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonsScreen(
                  lessons: physicsLessons, // your list of Lesson objects
                ),
              ),
            );
          }),
          const SizedBox(height: 32),
          _buildButton(context, "Chemistry", const Color(0xFF395886), () {
            // Navigate to the LessonsScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonsScreen(
                  lessons: chemistryLessons, // your list of Lesson objects
                ),
              ),
            );
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
                        backgroundColor: Color(0xFF8AAEE0),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          // side: BorderSide(color: Colors.black, width: 2),
                        ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "• Quizzes Completed: 12",
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  "• Badges Earned: 5",
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
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
                backgroundColor: Color(0xFF8AAEE0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  // side: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              child: Text(
                "Settings",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const Spacer(),

          // 🔹 Logout Button
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () async {
                await LocalStorage.setLoggedIn(false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(220, 50),
                backgroundColor: Color(0xFF8AAEE0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                "LOG OUT",
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Settings Page
  Widget _settingsContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(context, "Subjects", const Color(0xFF395886), () {
            setState(() {
              _showHomeContent = false;
              _selectedIndex = 0;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: 300,
      height: 95,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFF395886),
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Center(
          // <- ensures text is centered
          child: Text(
            text,
            textAlign: TextAlign.center, // <- extra safety
            style: GoogleFonts.poppins(
              fontSize: 26,
              shadows: [
                Shadow(
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(
                    0.3,
                  ), // fixed: use withOpacity
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
