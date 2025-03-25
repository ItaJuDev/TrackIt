class TransactionModel {
  final double amount;
  final String date;
  final bool isIncome;
  final String category;
  final String details;

  TransactionModel({
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.category,
    required this.details,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      amount: json['amount'].toDouble(),
      date: json['date'],
      isIncome: json['isIncome'],
      category: json['category'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'date': date,
      'isIncome': isIncome,
      'category': category,
      'details': details,
    };
  }
}
