import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/lessons/linear_algebra.dart';
import '../data/lessons/integral_calculus.dart';
import '../data/lessons/physics.dart';
import '../data/lessons/chemistry.dart';
import '../screens/lessons_list_screen.dart';
import '../widgets/hover_scale.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 HEADER
          Text(
            "What would you like to learn today?",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 SUBJECT CARDS
          _subjectCard(
            context,
            title: "Linear Algebra",
            subtitle: "Matrices, vectors, spaces",
            color: const Color(0xFFFBF0F7),
            iconPath: "assets/icons/linear.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonsScreen(
                    lessons: linearAlgebraLessons,
                    themeColor: const Color(0xFFFBF0F7),
                  ),
                ),
              );
            },
          ),

          _subjectCard(
            context,
            title: "Integral Calculus",
            subtitle: "Integration, areas",
            color: const Color(0xFFE2F2EF),
            iconPath: "assets/icons/calculus.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonsScreen(
                    lessons: integralCalculusLessons,
                    themeColor: const Color(0xFFE2F2EF),
                  ),
                ),
              );
            },
          ),

          _subjectCard(
            context,
            title: "Physics",
            subtitle: "Motion, energy, forces",
            color: const Color(0xFFF3F1EC),
            iconPath: "assets/icons/physics.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonsScreen(
                    lessons: physicsLessons,
                    themeColor: const Color(0xFFF3F1EC),
                  ),
                ),
              );
            },
          ),

          _subjectCard(
            context,
            title: "Chemistry",
            subtitle: "Atoms, reactions",
            color: const Color(0xFFFAF1C2),
            iconPath: "assets/icons/chemistry.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonsScreen(
                    lessons: chemistryLessons,
                    themeColor: const Color(0xFFFAF1C2),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _subjectCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Color color,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: HoverScale(
          hoverScale: 1.04,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                // 🔹 ICON
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(iconPath),
                  ),
                ),

                const SizedBox(width: 16),

                // 🔹 TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),

                // 🔹 ARROW
                const Icon(Icons.arrow_forward_ios_rounded, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
