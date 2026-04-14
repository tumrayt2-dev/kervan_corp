import 'package:flutter/material.dart';

class AppColors {
  static const Color bg      = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color border  = Color(0xFF2A3040);

  // Palet: teal + turuncu
  static const Color primary   = Color(0xFF22BABB); // parlak teal
  static const Color accent    = Color(0xFF348888); // koyu teal
  static const Color secondary = Color(0xFFFA7F08); // turuncu (para/vurgu)

  static const Color textPrimary   = Color(0xFFE8EDF2);
  static const Color textSecondary = Color(0xFF8B949E);

  static const Color error   = Color(0xFFF24405); // kırmızı-turuncu
  static const Color warning = Color(0xFFFA7F08); // turuncu
  static const Color success = Color(0xFF2ECC71); // yeşil (durum göstergesi)
}

class AppConstants {
  static const String packageName = 'com.kervancorp.app';
  static const int autoSaveIntervalSeconds = 30;
  static const int maxOfflineHours = 12;
}
