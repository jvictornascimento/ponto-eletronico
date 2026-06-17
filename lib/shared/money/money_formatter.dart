class MoneyFormatter {
  const MoneyFormatter._();

  static String formatCents(int cents) {
    return 'R\$ ${formatInputCents(cents)}';
  }

  static String formatInputCents(int cents) {
    final reais = cents ~/ 100;
    final centavos = (cents % 100).toString().padLeft(2, '0');

    return '$reais,$centavos';
  }

  static int parseToCents(String value) {
    final onlyNumbers = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (onlyNumbers.isEmpty) {
      return 0;
    }

    return int.parse(onlyNumbers);
  }
}
