class Settlement {
  final String fromMemberId;
  final String toMemberId;
  final int amountPaise;

  const Settlement({
    required this.fromMemberId,
    required this.toMemberId,
    required this.amountPaise,
  });

  double get amount => amountPaise / 100;
}
