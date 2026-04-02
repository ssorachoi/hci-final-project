import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'data/lessons/chemistry.dart';
import 'data/lessons/integral_calculus.dart';
import 'data/lessons/linear_algebra.dart';
import 'data/lessons/physics.dart';
import 'local_storage.dart';
import 'models/lesson.dart';

class SubjectProgressData {
  final String subjectTitle;
  final int completedLessons;
  final int totalLessons;
  final int correctAnswers;
  final int totalQuestions;
  final int quizzesTaken;
  final double progress;

  const SubjectProgressData({
    required this.subjectTitle,
    required this.completedLessons,
    required this.totalLessons,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.quizzesTaken,
    required this.progress,
  });

  String get quizLabel => '$correctAnswers/$totalQuestions';
}

class QuizCompletionRecord {
  final String lessonTitle;
  final String subjectTitle;
  final int correctAnswers;
  final int totalQuestions;
  final int percentage;
  final DateTime completedAt;

  const QuizCompletionRecord({
    required this.lessonTitle,
    required this.subjectTitle,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.percentage,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'lessonTitle': lessonTitle,
      'subjectTitle': subjectTitle,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'percentage': percentage,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory QuizCompletionRecord.fromMap(Map<String, dynamic> map) {
    return QuizCompletionRecord(
      lessonTitle: map['lessonTitle'] as String,
      subjectTitle: map['subjectTitle'] as String,
      correctAnswers: (map['correctAnswers'] as num).toInt(),
      totalQuestions: (map['totalQuestions'] as num).toInt(),
      percentage: (map['percentage'] as num).toInt(),
      completedAt: DateTime.parse(map['completedAt'] as String),
    );
  }
}

class ProgressSnapshot {
  final List<SubjectProgressData> subjects;
  final QuizCompletionRecord? recentQuiz;

  const ProgressSnapshot({required this.subjects, required this.recentQuiz});
}

class ProgressManager {
  static const _keyPrefix = 'progressData';

  static final Map<String, List<Lesson>> _subjectLessons = {
    'Linear Algebra': linearAlgebraLessons,
    'Integral Calculus': integralCalculusLessons,
    'Physics': physicsLessons,
    'Chemistry': chemistryLessons,
  };

  static Map<String, String> get _lessonToSubject {
    final map = <String, String>{};
    _subjectLessons.forEach((subject, lessons) {
      for (final lesson in lessons) {
        map[lesson.title] = subject;
      }
    });
    return map;
  }

  static Future<String> _userKey() async {
    final username = await LocalStorage.getCurrentUsername();
    return username ?? 'guest';
  }

  static Future<String> _storageKey() async {
    final userKey = await _userKey();
    return '$_keyPrefix-$userKey';
  }

  static Future<Map<String, dynamic>> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _storageKey();
    final raw = prefs.getString(key);
    if (raw == null) {
      return {
        'completedLessons': <String>[],
        'quizStats': <String, dynamic>{},
        'recentQuizzes': <dynamic>[],
      };
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return {
      'completedLessons': List<String>.from(decoded['completedLessons'] ?? []),
      'quizStats': Map<String, dynamic>.from(decoded['quizStats'] ?? {}),
      'recentQuizzes': List<dynamic>.from(decoded['recentQuizzes'] ?? []),
    };
  }

  static Future<void> _saveData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _storageKey();
    await prefs.setString(key, jsonEncode(data));
  }

  static Future<void> recordQuizCompletion({
    required String lessonTitle,
    required int correctAnswers,
    required int totalQuestions,
  }) async {
    final data = await _loadData();

    final completedLessons = List<String>.from(
      data['completedLessons'] as List,
    );
    if (!completedLessons.contains(lessonTitle)) {
      completedLessons.add(lessonTitle);
    }

    final quizStats = Map<String, dynamic>.from(data['quizStats'] as Map);
    final existing = Map<String, dynamic>.from(
      quizStats[lessonTitle] as Map? ?? {},
    );

    final attempts = ((existing['attempts'] as num?)?.toInt() ?? 0) + 1;
    final bestCorrect =
        ((existing['bestCorrect'] as num?)?.toInt() ?? 0) > correctAnswers
        ? (existing['bestCorrect'] as num).toInt()
        : correctAnswers;

    quizStats[lessonTitle] = {
      'attempts': attempts,
      'bestCorrect': bestCorrect,
      'lastCorrect': correctAnswers,
      'totalQuestions': totalQuestions,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    final subjectTitle = _lessonToSubject[lessonTitle] ?? 'Unknown Subject';
    final percentage = totalQuestions == 0
        ? 0
        : ((correctAnswers / totalQuestions) * 100).round();

    final recent = List<dynamic>.from(data['recentQuizzes'] as List);
    recent.insert(
      0,
      QuizCompletionRecord(
        lessonTitle: lessonTitle,
        subjectTitle: subjectTitle,
        correctAnswers: correctAnswers,
        totalQuestions: totalQuestions,
        percentage: percentage,
        completedAt: DateTime.now(),
      ).toMap(),
    );

    final trimmedRecent = recent.take(10).toList();

    await _saveData({
      'completedLessons': completedLessons,
      'quizStats': quizStats,
      'recentQuizzes': trimmedRecent,
    });
  }

  static Future<ProgressSnapshot> getProgressSnapshot() async {
    final data = await _loadData();
    final completedLessons = Set<String>.from(data['completedLessons'] as List);
    final quizStats = Map<String, dynamic>.from(data['quizStats'] as Map);
    final recentRaw = List<dynamic>.from(data['recentQuizzes'] as List);

    final subjects = <SubjectProgressData>[];

    _subjectLessons.forEach((subjectTitle, lessons) {
      final totalLessons = lessons.length;
      var completedCount = 0;
      var correctTotal = 0;
      var questionTotal = 0;
      var quizzesTaken = 0;

      for (final lesson in lessons) {
        if (completedLessons.contains(lesson.title)) {
          completedCount++;
        }

        final stat = Map<String, dynamic>.from(
          quizStats[lesson.title] as Map? ?? const {},
        );
        if (stat.isNotEmpty) {
          quizzesTaken += ((stat['attempts'] as num?)?.toInt() ?? 0);
          correctTotal += ((stat['bestCorrect'] as num?)?.toInt() ?? 0);
          questionTotal += ((stat['totalQuestions'] as num?)?.toInt() ?? 0);
        }
      }

      final lessonRatio = totalLessons == 0
          ? 0.0
          : completedCount / totalLessons;
      final quizRatio = questionTotal == 0 ? 0.0 : correctTotal / questionTotal;
      final progress = ((lessonRatio + quizRatio) / 2).clamp(0.0, 1.0);

      subjects.add(
        SubjectProgressData(
          subjectTitle: subjectTitle,
          completedLessons: completedCount,
          totalLessons: totalLessons,
          correctAnswers: correctTotal,
          totalQuestions: questionTotal,
          quizzesTaken: quizzesTaken,
          progress: progress,
        ),
      );
    });

    QuizCompletionRecord? recentQuiz;
    if (recentRaw.isNotEmpty) {
      recentQuiz = QuizCompletionRecord.fromMap(
        Map<String, dynamic>.from(recentRaw.first as Map),
      );
    }

    return ProgressSnapshot(subjects: subjects, recentQuiz: recentQuiz);
  }

  static Future<void> resetProgress() async {
    await _saveData({
      'completedLessons': <String>[],
      'quizStats': <String, dynamic>{},
      'recentQuizzes': <dynamic>[],
    });
  }
}
