class Transaction {
  final bool isIncome;
  final String category;
  final String details;
  final double amount;
  final DateTime date;

  Transaction({
    required this.amount,
    required this.category,
    required this.details,
    required this.date,
    required this.isIncome,
  });
}
