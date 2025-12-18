import 'package:intl/intl.dart';

/// Format angka ke format mata uang Rupiah yang benar sesuai EYD.
/// Contoh: 17000.50 -> "Rp17.000,50"
/// 
/// - Tidak ada spasi antara "Rp" dan angka
/// - Titik (.) sebagai pemisah ribuan
/// - Koma (,) sebagai pemisah desimal
String formatRupiah(double amount, {bool showDecimal = false}) {
  // Format angka dengan pemisah ribuan titik dan desimal koma (locale Indonesia)
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: showDecimal ? 2 : 0,
  );
  
  return formatter.format(amount);
}

/// Format angka ke format mata uang Rupiah dari int
String formatRupiahFromInt(int amount) {
  return formatRupiah(amount.toDouble(), showDecimal: false);
}
