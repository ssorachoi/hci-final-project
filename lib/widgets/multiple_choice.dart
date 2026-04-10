import 'package:flutter/material.dart';
import '../models/quiz_problem.dart';

class MultipleChoiceQuestion extends StatelessWidget {
  final QuizProblem problem;
  final String? selectedAnswer;
  final void Function(String) onAnswerSelected;

  const MultipleChoiceQuestion({
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
        Text(
          problem.question,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 30),
        ...?problem.options?.map(
          (option) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ElevatedButton(
              onPressed: () => onAnswerSelected(option),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: selectedAnswer == option
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 18,
                  color: selectedAnswer == option
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
