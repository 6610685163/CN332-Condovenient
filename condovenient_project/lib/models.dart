class Invoice {
  final String id;
  final double amount;
  final String dueDate;
  final String status; // 'Pending' หรือ 'Paid'

  Invoice({
    required this.id,
    required this.amount,
    required this.dueDate,
    required this.status,
  });
}
