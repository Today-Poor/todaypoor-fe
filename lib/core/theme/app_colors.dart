import 'package:flutter/material.dart';

/// Figma 디자인 색상 토큰 — 오늘의거지
///
/// 값이 Figma와 다르다면 담당자가 수정 후 PR에 명시해 주세요.
abstract final class AppColors {
  // ── Background ──────────────────────────────────────────
  static const Color backgroundTop = Color(0xFFFFFAEF);
  static const Color background = Color(0xFFF2E5C9);

  // ── Brand ────────────────────────────────────────────────
  /// 로고/타이틀 채움색 (카라멜 브라운)
  static const Color brandFill = Color(0xFFB8793A);

  /// 로고/타이틀 외곽선색 (다크 브라운)
  static const Color brandStroke = Color(0xFF2A1500);

  // ── Social login ─────────────────────────────────────────
  static const Color kakaoBackground = Color(0xFFFEE500);
  static const Color kakaoText = Color(0xFF191919);

  static const Color googleBackground = Colors.white;
  static const Color googleBorder = Color(0xFFDDD0BC);
  static const Color googleText = Color(0xFF1A1008);

  // ── Button ───────────────────────────────────────────────
  static const Color buttonCancel = Color(0xFFEBA9A9);
  static const Color buttonCreate = Color(0xFF9DC6A0);

  // ── Card ─────────────────────────────────────────────────
  static const Color cardBackground = Color(0xFFFAF7F0);
  static const Color cardBorder = Color(0xFFE8DCC8);

  // ── Input ────────────────────────────────────────────────
  static const Color inputBackground = Color(0xFFE8DCC8);

  // ── Text ─────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1008);
  static const Color textSecondary = Color(0xFFA7946F);
  static const Color textMuted = Color(0xFFB8A898);
}
