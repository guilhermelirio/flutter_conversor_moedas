import "package:intl/intl.dart";

String formatMoney(double value, {int decimal: 2}){
  if (value == null)
    return 'R\$ 0,00';
  return NumberFormat.currency(decimalDigits: decimal, locale: 'pt-br', symbol: 'R\$').format(value);
}

String formatMoney2(double value, String local, {int decimal: 2}){
  if (value == null)
    return 'R\$ 0,00';
  return NumberFormat.currency(decimalDigits: decimal, locale: local, symbol: '').format(value);
}

String formatNumber(double value, {int decimal: 2}){
  if (value == null)
    return '0';
  return NumberFormat.currency(decimalDigits: decimal, locale: 'pt-br', symbol: '').format(value);
}