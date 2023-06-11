class Question {
  final String question;
  final String correctAnswer;
  final List<String> options;

  Question({
    required this.question,
    required this.correctAnswer,
    required this.options,
  });

  static List<String> categories = [
    'General Knowledge',
    'Entertainment',
    'Science',
  ];
}
