import 'package:flutter/material.dart';
import '../models/quiz_problem.dart';

class TrueFalseQuestion extends StatelessWidget {
  final QuizProblem problem;
  final String? selectedAnswer;
  final void Function(String) onAnswerSelected;

  const TrueFalseQuestion({
    super.key,
    required this.problem,
    this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(problem.question, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ["True", "False"].map((option) {
            return ElevatedButton(
              onPressed: () => onAnswerSelected(option),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 50),
                backgroundColor: selectedAnswer == option ? Colors.blue : null,
              ),
              child: Text(option, style: const TextStyle(fontSize: 18)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
