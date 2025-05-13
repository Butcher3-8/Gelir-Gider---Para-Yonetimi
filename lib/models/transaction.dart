class Transaction {
  final String type;
  final String category;
  final double amount;
  final String description;
  final DateTime dateTime;

  Transaction({
    required this.type,
    required this.category,
    required this.amount,
    required this.description,
    required this.dateTime,
  });
}
