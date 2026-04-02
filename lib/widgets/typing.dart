import 'package:flutter/material.dart';
import '../models/quiz_problem.dart';

class TypingQuestion extends StatefulWidget {
  final QuizProblem problem;
  final String? initialText;
  final void Function(String) onAnswerSubmitted;

  const TypingQuestion({
    super.key,
    required this.problem,
    this.initialText,
    required this.onAnswerSubmitted,
  });

  @override
  State<TypingQuestion> createState() => _TypingQuestionState();
}

class _TypingQuestionState extends State<TypingQuestion> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    if (_controller.text.isNotEmpty) {
      widget.onAnswerSubmitted(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.problem.question, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 30),
        SizedBox(
          height: 60,
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Type your answer here",
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
            onSubmitted: (_) => _submitAnswer(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _submitAnswer,
          child: const Text("Submit", style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
