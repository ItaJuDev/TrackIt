class Transaction {
  final double amount;
  final DateTime date;
  final bool isIncome;
  final String category;
  final String details;

  Transaction({
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.category,
    required this.details,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      isIncome: json['isIncome'],
      category: json['category'],
      details: json['details'],
    );
  }
}
