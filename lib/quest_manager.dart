import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'data/lessons/chemistry.dart';
import 'data/lessons/integral_calculus.dart';
import 'data/lessons/linear_algebra.dart';
import 'data/lessons/physics.dart';
import 'local_storage.dart';
import 'models/quest.dart';

class QuestCompletionResult {
  final List<Quest> completedQuests;
  final int totalExpReward;
  final int totalCoinReward;
  final int currentExp;
  final int currentCoins;
  final int currentLevel;

  const QuestCompletionResult({
    required this.completedQuests,
    required this.totalExpReward,
    required this.totalCoinReward,
    required this.currentExp,
    required this.currentCoins,
    required this.currentLevel,
  });

  bool get hasRewards => completedQuests.isNotEmpty;
}

class QuestManager {
  static List<String> get _allLessonTitles {
    return [
      ...linearAlgebraLessons,
      ...integralCalculusLessons,
      ...physicsLessons,
      ...chemistryLessons,
    ].map((lesson) => lesson.title).toList();
  }

  static const _questDatePrefix = 'dailyQuestDate';
  static const _questCompletionPrefix = 'dailyQuestCompletion';

  static String _dateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static Future<String?> _currentUserKey() async {
    final username = await LocalStorage.getCurrentUsername();
    return username;
  }

  static Future<Map<String, bool>> _loadCompletionMap(DateTime now) async {
    final username = await _currentUserKey();
    if (username == null) return {};

    final prefs = await SharedPreferences.getInstance();
    final dateToken = _dateKey(now);
    final dateKey = '$_questDatePrefix-$username';
    final completionKey = '$_questCompletionPrefix-$username';

    final storedDate = prefs.getString(dateKey);
    if (storedDate != dateToken) {
      await prefs.setString(dateKey, dateToken);
      await prefs.setString(completionKey, jsonEncode(<String, bool>{}));
      return {};
    }

    final raw = prefs.getString(completionKey);
    if (raw == null) return {};

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, v == true));
  }

  static Future<void> _saveCompletionMap(Map<String, bool> map) async {
    final username = await _currentUserKey();
    if (username == null) return;

    final prefs = await SharedPreferences.getInstance();
    final completionKey = '$_questCompletionPrefix-$username';
    await prefs.setString(completionKey, jsonEncode(map));
  }

  static Quest _anyLessonQuest() {
    return const Quest(
      id: 'any-lesson',
      title: 'Daily Starter',
      lessonTitle: '*',
      expReward: 20,
      coinReward: 10,
    );
  }

  static Quest _specificLessonQuest(List<String> lessonTitles, DateTime now) {
    if (lessonTitles.isEmpty) {
      return const Quest(
        id: 'specific-fallback',
        title: 'Lesson Specialist',
        lessonTitle: '*',
        expReward: 30,
        coinReward: 15,
      );
    }

    final index = now.day % lessonTitles.length;
    final lessonTitle = lessonTitles[index];

    return Quest(
      id: 'specific-${lessonTitle.toLowerCase().replaceAll(' ', '-')}',
      title: 'Lesson Specialist',
      lessonTitle: lessonTitle,
      expReward: 35,
      coinReward: 20,
    );
  }

  static Quest _doubleRewardQuest(List<String> lessonTitles, DateTime now) {
    if (lessonTitles.isEmpty) {
      return const Quest(
        id: 'double-fallback',
        title: 'Momentum Bonus',
        lessonTitle: '*',
        expReward: 45,
        coinReward: 25,
      );
    }

    final index = (now.day + now.month) % lessonTitles.length;
    final lessonTitle = lessonTitles[index];

    return Quest(
      id: 'momentum-${lessonTitle.toLowerCase().replaceAll(' ', '-')}',
      title: 'Momentum Bonus',
      lessonTitle: lessonTitle,
      expReward: 50,
      coinReward: 30,
    );
  }

  static List<Quest> _baseQuests(List<String> lessonTitles, DateTime now) {
    return [
      _anyLessonQuest(),
      _specificLessonQuest(lessonTitles, now),
      _doubleRewardQuest(lessonTitles, now),
    ];
  }

  static Future<List<Quest>> getDailyQuests({
    List<String>? lessonTitles,
    DateTime? now,
  }) async {
    final refNow = now ?? DateTime.now();
    final completionMap = await _loadCompletionMap(refNow);
    final base = _baseQuests(lessonTitles ?? _allLessonTitles, refNow);

    return base
        .map(
          (quest) =>
              quest.copyWith(isCompleted: completionMap[quest.id] == true),
        )
        .toList();
  }

  static Future<QuestCompletionResult> completeQuestsForLesson({
    required String lessonTitle,
    DateTime? now,
  }) async {
    final username = await _currentUserKey();
    if (username == null) {
      return const QuestCompletionResult(
        completedQuests: [],
        totalExpReward: 0,
        totalCoinReward: 0,
        currentExp: 0,
        currentCoins: 0,
        currentLevel: 1,
      );
    }

    final refNow = now ?? DateTime.now();
    final quests = await getDailyQuests(now: refNow);
    final completionMap = await _loadCompletionMap(refNow);

    final completed = <Quest>[];
    var totalExp = 0;
    var totalCoins = 0;

    for (final quest in quests) {
      if (quest.isCompleted) {
        continue;
      }
      if (!quest.matchesLesson(lessonTitle)) {
        continue;
      }

      completionMap[quest.id] = true;
      completed.add(quest.copyWith(isCompleted: true));
      totalExp += quest.expReward;
      totalCoins += quest.coinReward;
    }

    if (completed.isEmpty) {
      return QuestCompletionResult(
        completedQuests: const [],
        totalExpReward: 0,
        totalCoinReward: 0,
        currentExp: await LocalStorage.getExp(),
        currentCoins: await LocalStorage.getCoins(),
        currentLevel: await LocalStorage.getLevel(),
      );
    }

    await _saveCompletionMap(completionMap);
    final currentExp = await LocalStorage.addExp(totalExp);
    final currentCoins = await LocalStorage.addCoins(totalCoins);
    final currentLevel = await LocalStorage.getLevel();

    return QuestCompletionResult(
      completedQuests: completed,
      totalExpReward: totalExp,
      totalCoinReward: totalCoins,
      currentExp: currentExp,
      currentCoins: currentCoins,
      currentLevel: currentLevel,
    );
  }
}
