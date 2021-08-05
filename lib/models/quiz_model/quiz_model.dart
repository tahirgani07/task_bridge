class QuizModel {
  static double calculateRatingFromScore(int score, int totalScore) {
    double rating = 0;
    double percentage = score * 100 / totalScore;
    rating = percentage / 20;
    return double.parse(rating.toStringAsFixed(2));
  }
}

class Question {
  final String question;
  final String op1;
  final String op2;
  final String op3;
  final String op4;
  final String answer;

  Question({
    required this.question,
    required this.op1,
    required this.op2,
    required this.op3,
    required this.op4,
    required this.answer,
  });
}
