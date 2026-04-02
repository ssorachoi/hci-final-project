class Quest {
  final String id;
  final String title;
  final String lessonTitle;
  final int expReward;
  final int coinReward;
  final bool isCompleted;

  const Quest({
    required this.id,
    required this.title,
    required this.lessonTitle,
    required this.expReward,
    required this.coinReward,
    this.isCompleted = false,
  });

  bool get matchesAnyLesson => lessonTitle == '*';

  bool matchesLesson(String completedLessonTitle) {
    if (matchesAnyLesson) return true;
    return lessonTitle.toLowerCase() == completedLessonTitle.toLowerCase();
  }

  Quest copyWith({
    String? id,
    String? title,
    String? lessonTitle,
    int? expReward,
    int? coinReward,
    bool? isCompleted,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      expReward: expReward ?? this.expReward,
      coinReward: coinReward ?? this.coinReward,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'lessonTitle': lessonTitle,
      'expReward': expReward,
      'coinReward': coinReward,
      'isCompleted': isCompleted,
    };
  }

  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      id: map['id'] as String,
      title: map['title'] as String,
      lessonTitle: map['lessonTitle'] as String,
      expReward: (map['expReward'] as num).toInt(),
      coinReward: (map['coinReward'] as num).toInt(),
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }
}
